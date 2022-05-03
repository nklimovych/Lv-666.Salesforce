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
                Double lat;
                Double lng;
                JSONParser parser = JSON.createParser(response.getBody());
                while (parser.nextToken() != null) {
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                        (parser.getText() == 'geometry')) {
                        // Get the value.
                        parser.nextToken();
                        parser.nextToken();
                        parser.nextToken();
                        // Compute the grand total price for all invoices.
                        lat = parser.getDoubleValue();
                        parser.nextToken();
                        parser.nextToken();
                        lng = parser.getDoubleValue();
                    }
                }
                UpdateVoteCampaignLocationCoordinates updcoordinatesjob = new UpdateVoteCampaignLocationCoordinates(votecamplocid, lat, lng);
                ID updcoordinatesjobid = System.enqueueJob(updcoordinatesjob);
                //AsyncApexJob updcoordinatesjob_log = [SELECT Id, Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :updcoordinatesjobid];
                //System.debug('Update coordinates job log: ' + updcoordinatesjob_log);
            } else {
                System.debug('Ivalid request: ' + response.getStatusCode());
            }
        }
    }
}
