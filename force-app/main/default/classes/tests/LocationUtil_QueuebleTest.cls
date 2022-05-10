/**
 * contains tests for LocationUtil_Queuebl class
 */
@isTest
public with sharing class LocationUtil_QueuebleTest {
    /**
     * @description test metod for LocationUtil_Queueble class
     */
    @isTest
    public static void testAddCoordinate() {
        Test.setMock(HttpCalloutMock.class, new LocationUtil_QueuebleMock());
		Location_for_Campaing__c location = new Location_for_Campaing__c();
        LocationUtil_Queueble locationUnit = new LocationUtil_Queueble();
        location.Name = 'Test';
        location.Street__c = 'Rua Cafelândia';
        location.City__c = 'Carapicuíba';
        location.Country__c = 'Brasil';
        location.Zip__c = 06321;
        location = locationUnit.addCoordinate(location);
        Test.startTest();
        insert location;
        Test.stopTest();
        System.assertEquals(-23.5370962, [SELECT Latitude__c FROM Location_for_Campaing__c WHERE name = 'Test' LIMIT 1].Latitude__c);
        System.assertEquals(-46.8359735, [SELECT Longitude__c FROM Location_for_Campaing__c WHERE name = 'Test' LIMIT 1].Longitude__c);
    }
    /**
     * @description test metod for isUpdateNeeded method of LocationUtil_Queueble class
     */
    @isTest
    public static void isUpdateNeededTest(){
        LocationUtil_Queueble locationUnit = new LocationUtil_Queueble();
        Location_for_Campaing__c OldLocation = new Location_for_Campaing__c();
        OldLocation.Street__c = 'Rua Cafelândia';
        OldLocation.City__c = 'Carapicuíba';
        OldLocation.Country__c = 'Brasil';
        Location_for_Campaing__c newLocation = OldLocation.clone(true, false, false, false);
        newLocation.Zip__c = 06381;
        List<Location_for_Campaing__c> oldLocations = new List<Location_for_Campaing__c>{OldLocation};
        List<Location_for_Campaing__c> newLocations = new List<Location_for_Campaing__c>{newLocation};
        System.assertEquals(false, locationUnit.isUpdateNeeded(oldLocations, oldLocations));
        System.assertEquals(true, locationUnit.isUpdateNeeded(oldLocations, newLocations));
    }
}
