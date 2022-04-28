/**
 * Represents integration for getting data from external service
 */
public with sharing class GeoLocationIntegration implements Queueable, Database.AllowsCallouts{
    
    List<Voting_Location__c> locations = new List<Voting_Location__c>();

    public GeoLocationIntegration(List<Voting_Location__c> locations) {
        this.locations = locations;
    }

    /**
     * Method asynchronously get data from web service and update Location__c object
     */
    public void execute(QueueableContext context){
        String key = [SELECT opencagedataKey__c FROM API_key_for_opencagedata__mdt Limit 1].opencagedataKey__c;

        List<Voting_location__c> locationsToUpdate = new List<Voting_Location__c>();

        for(Voting_Location__c currLocation: locations){
            Voting_Location__c updatedLocation = currLocation.clone(true, false, false, false);

            Http httpInstance = new Http();
            
            
            String forRequest = updatedLocation.Mailing_City__c + ', ' + updatedLocation.Mailing_Street__c + ', ' + updatedLocation.Mailing_Country__c;
            String encoded = EncodingUtil.urlEncode(forRequest, 'UTF-8');
            HttpRequest request = new HttpRequest();
            
            request.setEndpoint('https://api.opencagedata.com/geocode/v1/json?q=' + encoded +'&key=' + key);
            
            request.setMethod('GET');
            HttpResponse response = httpInstance.send(request);
            String test = response.getBody();
            System.debug(test);
            if(response.getStatusCode() == 200){
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());  
                Map<String, Object> coordinatesValuesMap = parseJSON(responseMap);
                
                updatedLocation.Location_lat__c = getFirstCoordinate(coordinatesValuesMap);
                updatedLocation.Location_lng__c = getSecondCoordinate(coordinatesValuesMap);
              
                locationsToUpdate.add(updatedLocation);
            }
        }

        GeoLocationIntegrationTriggerHandler.isActive = false;
        try{
        update locationsToUpdate;
        } catch(Exception e){
            ExceptionUtility error = new ExceptionUtility(e);
            System.enqueueJob(error);
        }
        GeoLocationIntegrationTriggerHandler.isActive = true;
    }
    
    /**
     * Method for parcing JSON File
     */
    public Map<String, Object> parseJSON(Map<String, Object> responseMap){
        List<Object> listOfResponses = (List<Object>) responseMap.get('results');
        Map<String, Object> resultsValues = (Map<String, Object>) listOfResponses.get(0);
        Map<String, Object> annotationValues = (Map<String, Object>) resultsValues.get('annotations');
        Map<String, Object> DMSValues = (Map<String, Object>) annotationValues.get('DMS');

        return DMSValues;
    }

    /*
    * Getting the first coordinate value from parsedJSON
    */
    public String getFirstCoordinate(Map<String, Object> parsedJSON){
        return (String) parsedJSON.get('lat');
    }

    /*
    * Getting the second coordinate value from parsedJSON
    */
    public String getSecondCoordinate(Map<String, Object> parsedJSON){
        return (String) parsedJSON.get('lng');
    }
}
