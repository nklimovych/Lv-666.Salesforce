public with sharing class MakeCallout {

    public static HttpResponse getCallout(String key, Voting_Location__c locationToUpdate){
        Http httpInstance = new Http();
        String forRequest = locationToUpdate.Mailing_City__c + ', ' + locationToUpdate.Mailing_Street__c + ', ' + locationToUpdate.Mailing_Country__c;
        String encoded = EncodingUtil.urlEncode(forRequest, 'UTF-8');
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.opencagedata.com/geocode/v1/json?q=' + encoded +'&key=' + key);
        request.setMethod('GET');
        
        HttpResponse response = httpInstance.send(request);
        
        return response;
    }
}
