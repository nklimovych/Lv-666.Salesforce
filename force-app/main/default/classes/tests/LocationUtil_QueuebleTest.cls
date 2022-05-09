/**
 * contains tests for LocationUtil_Queuebl class
 */
@isTest
public with sharing class LocationUtil_QueuebleTest {
    //number of locations to insert
    private static final Integer NUMBER_OF_INSERTS = 20;
    /**
     * @description setup description
     */ 
    @TestSetup
    static void setup(){
        //creating and inserting initial list of locations
        List<Location_for_Campaing__c> locations = new List<Location_for_Campaing__c>();
        //20 items to check bulk insert
        for(Integer i = 0; i < NUMBER_OF_INSERTS; i++){
            locations.add( new Location_for_Campaing__c(Name = 'test' + i, Street__c = 'Doroshenka ' + i, Country__c = 'UA', City__c = 'Lviv'));
        }
        Test.startTest();
        insert locations;
        Test.stopTest();
    }
     /**
     * @description test metod for insert of Location for Campaing objects
     */
    @isTest
    static void updateInsertedLocationsTest(){
        //creating list of names for test groups
        Integer numberOfCreatdCoordinates = 0 ;
        //check if Longitude and Latitude were created
        for(Location_for_Campaing__c location :[SELECT Latitude__c,Longitude__c FROM Location_for_Campaing__c WHERE Name LIKE 'Test%' ]){
            if((location.Latitude__c != null) && (location.Longitude__c != null))
                numberOfCreatdCoordinates++;
        }
        System.assertEquals(LocationUtil_QueuebleTest.NUMBER_OF_INSERTS, numberOfCreatdCoordinates);
    }

}
