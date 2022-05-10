public without sharing class GetCoordinatesFromAddresses implements Queueable, Database.AllowsCallouts {
    private List<VoteCampaignLocation__c> voteCampaignLocations;
    private final String API_KEY = '86f3118eaf2942e89bd8e1bd7d148add';
    public GetCoordinatesFromAddresses(List<VoteCampaignLocation__c> voteCampLocations) {
        this.voteCampaignLocations = voteCampLocations;
    }

    public void execute (QueueableContext context) {
        for(VoteCampaignLocation__c voteCampLoc : voteCampaignLocations) {
            Id voteCampLocId = voteCampLoc.id;
            String requestAddress = voteCampLoc.Street__c + ', ' + voteCampLoc.City__c + ', ' + voteCampLoc.Country__c;
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
                UpdateVoteCampaignLocationCoordinates updCoordinatesJob = new UpdateVoteCampaignLocationCoordinates(voteCampLocId, lat, lng);
                ID updCoordinatesJobId = System.enqueueJob(updCoordinatesJob);
                //AsyncApexJob updCoordinatesJob_Log = [SELECT Id, Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :updCoordinatesJobId];
                //System.debug('Update coordinates job log: ' + updCoordinatesJob_Log);
            } else {
                System.debug('Ivalid request: ' + response.getStatusCode());
            }
        }
    }

    public Map<String, Object> parseJSON(Map<String, Object> responseMap) {
        List<Object> responsesList = (List<Object>) responseMap.get('results');
        Map<String, Object> resultsValues = (Map<String, Object>) responsesList.get(0);
        return (Map<String, Object>) resultsValues.get('geometry');
    }

    public Double getCoordinates(Map<String, Object> parsedJSON, String fieldName) {
        Double geometryCoordinates = (Double) parsedJSON.get(fieldName);
        return geometryCoordinates;
    }
}