public with sharing class CalloutToExternalServise implements Queueable, Database.AllowsCallouts{
    
    List<Voting_Location__c> lstOfLocations = new List<Voting_Location__c>();

    public CalloutToExternalServise(List<Voting_Location__c> lstOfLocations) {
        this.lstOfLocations = lstOfLocations.deepClone(true, false, false);
    }

    public void execute(QueueableContext context){
        String key = [SELECT opencagedataKey__c FROM API_key_for_opencagedata__mdt Limit 1].opencagedataKey__c;

        for(Voting_Location__c currLocation: lstOfLocations){
            Http httpInstance = new Http();
            
            
            String locationStreetWithoutSpaces = currLocation.Mailing_Street__c.replaceAll('(\\s+)', '');
            String locationCountryWithoutSpaces = currLocation.Mailing_Country__c.replaceAll('(\\s+)', '');
            String locationCityWithoutSpaces = currLocation.Mailing_City__c.replaceAll('(\\s+)', '');

            HttpRequest request = new HttpRequest();
            
            request.setEndpoint('https://api.opencagedata.com/geocode/v1/json?q=' +
            locationCountryWithoutSpaces + ',' +
            locationCityWithoutSpaces + ',' +
            locationStreetWithoutSpaces + ',' +
            '&key=' + key);

            request.setMethod('GET');
            HttpResponse response = httpInstance.send(request);
            Map<String, Object> mapOfResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());  
            
            String firstCoordinate = getFirstCoordinate(parseJSON(mapOfResponse));
            String secondCoordinate = getSecondCoordinate(parseJSON(mapOfResponse));
            
            currLocation.Location_lat__c = firstCoordinate;
            currLocation.Location_lng__c = secondCoordinate;
            System.debug(currLocation.Location_lat__c);
            System.debug(currLocation.Location_lng__c);

        }
    }
    
    public Map<String, Object> parseJSON(Map<String, Object> mapOfJSON){
        List<Object> listOfResponses = (List<Object>) mapOfJSON.get('results');
        Map<String, Object> resultsValues = (Map<String, Object>) listOfResponses.get(0);
        Map<String, Object> annotationValues = (Map<String, Object>) resultsValues.get('annotations');
        Map<String, Object> DMSValues = (Map<String, Object>) annotationValues.get('DMS');

        return DMSValues;
    }

    public String getFirstCoordinate(Map<String, Object> parsedJSON){
        return (String) parsedJSON.get('lat');
    }

    public String getSecondCoordinate(Map<String, Object> parsedJSON){
        return (String) parsedJSON.get('lng');
    }
}
