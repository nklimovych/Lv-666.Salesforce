public without sharing class GetCoordinatesFromAddresses implements Queueable, Database.AllowsCallouts {
    private List<VoteCampaignLocation__c> voteCampaignLocations;
    private final String API_KEY = '86f3118eaf2942e89bd8e1bd7d148add';
    public GetCoordinatesFromAddresses(List<VoteCampaignLocation__c> voteCampaignLocations) {
        this.voteCampaignLocations = voteCampaignLocations;
    }

    public void execute (QueueableContext context) {
        for(VoteCampaignLocation__c votecamploc : voteCampaignLocations) {
            Id votecamplocid = votecamploc.id;
            String requestAddress = votecamploc.Street__c + ', ' + votecamploc.City__c + ', ' + votecamploc.Country__c;
            String encodedRequestAddress = EncodingUtil.urlEncode(requestAddress, 'UTF-8');
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://api.opencagedata.com/geocode/v1/json?q=' + encodedRequestAddress + '&key=' + API_KEY + '&pretty=1&limit=1');
            request.setMethod('GET');
            request.setTimeout(1000);
            Http http = new Http();
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 200) {
                Map<String, Object> coordinateValuesMap = parseJSON((Map<String, Object>)JSON.deserializeUntyped(response.getBody()));
                Double lat = getCoordinates(coordinateValuesMap, 'lat');
                Double lng = getCoordinates(coordinateValuesMap, 'lng');
                UpdateVoteCampaignLocationCoordinates updcoordinatesjob = new UpdateVoteCampaignLocationCoordinates(votecamplocid, lat, lng);
                ID updcoordinatesjobid = System.enqueueJob(updcoordinatesjob);
                //AsyncApexJob updcoordinatesjob_log = [SELECT Id, Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :updcoordinatesjobid];
                //System.debug('Update coordinates job log: ' + updcoordinatesjob_log);
            } else {
                System.debug('Ivalid request: ' + response.getStatusCode());
            }
        }
    }

    public Map<String, Object> parseJSON(Map<String, Object> responseMap) {
        List<Object> listOfResponses = (List<Object>) responseMap.get('results');
        Map<String, Object> resultsValues = (Map<String, Object>) listOfResponses.get(0);
        return (Map<String, Object>) resultsValues.get('geometry');
    }

    public Double getCoordinates(Map<String, Object> parsedJSON, String fieldName) {
        Double geometryCoordinates = (Double) parsedJSON.get(fieldName);
        return geometryCoordinates;
    }
}