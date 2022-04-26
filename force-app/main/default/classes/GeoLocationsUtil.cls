public with sharing class GeoLocationsUtil {

    private List<Voting_Location__c> lstOfLocations = new List<Voting_Location__c>();
    private static Map<String, Object> mapOfJSON = new Map<String, Object>();

    private String firstCoordinate;
    private String secondCoordinate;

    public GeoLocationsUtil(List<Voting_Location__c> lstOflocations){
        this.lstOfLocations = lstOflocations;
    }

    public void getGeoLocation(){
        for(Voting_Location__c currLocation: lstOfLocations){
            Id jobId = System.enqueueJob(new CalloutToExternalServise(currLocation));
            AsyncApexJob job = [SELECT Status FROM AsyncApexJob WHERE Id = :jobId];
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.opencagedata.com/geocode/v1/json?q=' + currLocation.Mailing_Country__c + ',' + currLocation.Mailing_City__c + ',' + currLocation.Mailing_Street__c + ',' + '&key=' + key);
        request.setMethod('GET');
        
        HttpResponse response = httpInstance.send(request);
        Map<String, Object> mapOfJSON = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());  
        
        firstCoordinate = getFirstCoordinate(parseJSON(mapOfJSON));
        secondCoordinate = getSecondCoordinate(parseJSON(mapOfJSON));
        System.debug(firstCoordinate + ', '+ secondCoordinate);
        }
    }
    
    public Map<String, Object> parseJSON(Map<String, Object> mapOfJSON){
        List<Object> listOfResponses = (List<Object>) mapOfJSON.get('results');
        Map<String, Object> resultsValues = (Map<String, Object>) listOfResponses.get(0);
        Map<String, Object> annotationValues = (Map<String, Object>) resultsValues.get('annotations');
        Map<String, Object> DMSValues = (Map<String, Object>) annotationValues.get('DMS');

        return DMSValues;
    }

    // public static void getLocationCoordinates(List<Voting_Location__c> campaignLocations) {
    //     System.debug('we are in the method');
    //     String key = [SELECT opencagedataKey__c FROM API_key_for_opencagedata__mdt Limit 1].opencagedataKey__c;
    //     System.debug('key = ' + key);
    //     for(Voting_Location__c tempVar: campaignLocations){
    //         // Map<String, Object> mapToParse = createCalloutToWebService(key, tempVar.Mailing_Country__c, tempVar.Mailing_City__c, tempVar.Mailing_Street__c);
    //         createCalloutToWebService(key, tempVar.Mailing_Country__c, tempVar.Mailing_City__c, tempVar.Mailing_Street__c);
    //         Map<String, Object> mapToParse = mapOfJSON;
    //         System.debug('Map to Parse: ' + mapToParse);
    //         String firstCoordinate = getFirstCoordinate(parseJSON(mapToParse));
    //         String secondCoordinate = getSecondCoordinate((parseJSON(mapToParse)));
    //         System.debug(firstCoordinate + ',' +secondCoordinate);
    //     }
    // }
    
    // public static Map<String, Object> parseJSON(Map<String, Object> JSON_Map){
    //     // List<Object> listOfResponses = (List<Object>) JSON_Map.get('results');
    //     // Map<String, Object> resultsValues = (Map<String, Object>) listOfResponses.get(0);
    //     // Map<String, Object> annotationValues = (Map<String, Object>) resultsValues.get('annotations');
    //     // Map<String, Object> DMSValues = (Map<String, Object>) annotationValues.get('DMS');
    //     return DMSValues;
    // }

    //Getting first part of coordinates
    public static String getFirstCoordinate(Map<String, Object> parsedJSON){
        return (String) parsedJSON.get('lat');
    }

    // Getting second part of coordinates
    public static String getSecondCoordinate(Map<String, Object> parsedJSON){
        return (String) parsedJSON.get('lng');
    }

    //Creating callout to external servise
    // @future(callout=true)
    // public static void createCalloutToWebService(String key, String MailingCountry, String MailingCity, String MailingStreet) {
    //     Http httpInstance = new Http();
        
    //     // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    //     HttpRequest request = new HttpRequest();
    //     request.setEndpoint('https://api.opencagedata.com/geocode/v1/json?q=' + MailingCountry + ',' + MailingCity + ',' + MailingStreet + ',' + '&key=' + key);
    //     request.setMethod('GET');

    //     HttpResponse response = httpInstance.send(request);
    //     Map<String, Object> mapOfJSON = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());  
    //     List<Object> listOfResponses = (List<Object>) JSON_Map.get('results');
    //     Map<String, Object> resultsValues = (Map<String, Object>) listOfResponses.get(0);
    //     Map<String, Object> annotationValues = (Map<String, Object>) resultsValues.get('annotations');
    //     Map<String, Object> DMSValues = (Map<String, Object>) annotationValues.get('DMS');
        
    //     //mapOfJSON = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());   
    //     System.debug('Maps of JSON: ' + mapOfJSON);
    //     //Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());   
        
    
}

