/**
 * Represents integration for getting data from external service
 */
public with sharing class GeoLocationIntegration implements Queueable, Database.AllowsCallouts{
    
    List<Voting_Location__c> locations = new List<Voting_Location__c>();
    String key;
    public GeoLocationIntegration(String key, List<Voting_Location__c> locations) {
        this.locations = locations;
        this.key = key;
    }

    /**
     * Method asynchronously get data from web service and update Voting_Location__c object
     */
    public void execute(QueueableContext context){
        List<Voting_Location__c> locationsToUpdate = new List<Voting_Location__c>();

        for(Voting_Location__c currLocation: locations){
            Voting_Location__c updatedLocation = currLocation.clone(true, false, false, false);
            
            HttpResponse response = MakeCallout.getCallout(key, updatedLocation);
        
            if(response.getStatusCode() == 200){
                Map<String, Object> coordinateValuesMap = parseJSON((Map<String, Object>)JSON.deserializeUntyped(response.getBody()));  
                
                updatedLocation.Location_lat__c = getFirstCoordinate(coordinateValuesMap);
                updatedLocation.Location_lng__c = getSecondCoordinate(coordinateValuesMap);
                System.debug(updatedLocation.Location_lat__c);
                System.debug(updatedLocation.Location_lng__c);
                locationsToUpdate.add(updatedLocation);
            }
        }

        try{
        update locationsToUpdate;
        } catch(Exception e){
            ExceptionUtility error = new ExceptionUtility(e);
            System.enqueueJob(error);
        }
    }
    
    /**
     * Method for parcing JSON File
     */
    public Map<String, Object> parseJSON(Map<String, Object> responseMap){
        List<Object> listOfResponses = (List<Object>) responseMap.get('results');
        Map<String, Object> resultsValues = (Map<String, Object>) listOfResponses.get(0);

        return (Map<String, Object>) resultsValues.get('geometry');
    }

    /*
    * Getting the first coordinate value from parsedJSON
    */
    public String getFirstCoordinate(Map<String, Object> parsedJSON){
        Decimal geometryLatitude = (Decimal) parsedJSON.get('lat');
        return String.valueOf(geometryLatitude);
        //return (String) parsedJSON.get('lat');
    }

    /*
    * Getting the second coordinate value from parsedJSON
    */
    public String getSecondCoordinate(Map<String, Object> parsedJSON){
        Decimal geometryLatitude = (Decimal) parsedJSON.get('lng');
        return String.valueOf(geometryLatitude);
        //return (String) parsedJSON.get('lng');
    }
}
