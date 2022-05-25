@isTest
public with sharing class GeoLocationIntegrationTest {

    @isTest static void executeMethod(){
        Test.setMock(HttpCalloutMock.class, new MakeCalloutMock());
        List<Voting_Location__c> locations = new List<Voting_Location__c>();
        locations.add(new Voting_Location__c(
                Mailing_Country__c = 'Germany',
                Mailing_City__c = 'Berlin',
                Mailing_Street__c = 'Bismarckstraße 35',
                Name = 'test'
            )
        );

        Test.startTest();
        insert locations;
        Test.stopTest();
        
        Voting_Location__c c = [SELECT Location_lat__c, Location_lng__c FROM Voting_Location__c WHERE Name = 'test'];
        System.assertEquals('52.5121441',c.Location_lat__c);
        System.assertEquals('13.3083771', c.Location_lng__c);
    }
}
