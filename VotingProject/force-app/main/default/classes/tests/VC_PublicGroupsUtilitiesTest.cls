/*
    Apex Class Name:  VC_PublicGroupsUtilitiesTest
                      (Namespace "VC" stands for Voting Campaign)
    @description: This class is designed to test public groups creation after inserting or undeleting 
                  voting campaigns records and its deletion after deleting voting campaigns records
*/
@isTest
public with sharing class VC_PublicGroupsUtilitiesTest {
/*
    @description: TestSetup creates data for testing
*/
    @testSetup 
    static void setup(){
        //creating records on voting campaign object
        List<Voting_Campaign__c> testCampaigns = new List<Voting_Campaign__c>();
        Integer campaignsQuantity = 10;
        for(Integer i = 0; i < campaignsQuantity; i++){
            testCampaigns.add(new Voting_Campaign__c(
                Campaign_Name__c = 'TestCampaign' + i,
                Voting_Start_Date__c = Date.TODAY(),
                Voting_End_Date__c = Date.TODAY()));
        }
        Test.startTest();
        insert testCampaigns;
        Test.stopTest();
    }
/*
    @description: Method for testing public groups creation after inserting voting campaign records
*/
    @isTest static void createPublicGroupsTest() {
        // retrieving Campaigns RecordType.Names that are the parts of group names
        Set<ID> campaignsIds = (new Map<ID, SObject>([SELECT Id FROM Voting_Campaign__c WHERE Campaign_Name__c LIKE 'Test%']).keySet());
        List<String> campaignsNames = new List<String>();
        for(Voting_Campaign__c testCampaign: [SELECT Name FROM Voting_Campaign__c WHERE Id IN :campaignsIds]){
            campaignsNames.add('%' + testCampaign.Name + '%');
        }
        // checking results - should be created 4 public groups per campaign, expected result is 40 in this case
        Integer actualResult = [SELECT COUNT() FROM Group WHERE Name LIKE :campaignsNames];
        System.assertEquals(40, actualResult);
    }
/*
    @description: Method for testing public groups deletion after deleting voting campaign records
*/
    @isTest static void deletePublicGroupsTest(){
        // retrieving Campaigns RecordType.Names that are the parts of group names
        List<Voting_Campaign__c> testCampaigns = [SELECT Id FROM Voting_Campaign__c WHERE Campaign_Name__c LIKE 'Test%'];
        Set<ID> campaignsIds = (new Map<ID, SObject>(testCampaigns).keySet());
        List<String> campaignsNames = new List<String>();
        for(Voting_Campaign__c testCampaign: [SELECT Name FROM Voting_Campaign__c WHERE Id IN :campaignsIds]){
            campaignsNames.add('%' + testCampaign.Name + '%');
        }

        delete testCampaigns;
        // checking results - all public groups should be deleted, expected result is 0
        Integer actualResult = [SELECT COUNT() FROM Group WHERE Name LIKE :campaignsNames];
        System.assertEquals(0, actualResult);
    }
    @isTest static void undeletePublicGroupsTest(){
        // retrieving Campaigns RecordType.Names that are the parts of group names
        List<Voting_Campaign__c> testCampaigns = [SELECT Id FROM Voting_Campaign__c WHERE Campaign_Name__c LIKE 'Test%'];
        Set<ID> campaignsIds = (new Map<ID, SObject>(testCampaigns).keySet());
        List<String> campaignsNames = new List<String>();
        for(Voting_Campaign__c testCampaign: [SELECT Name FROM Voting_Campaign__c WHERE Id IN :campaignsIds]){
            campaignsNames.add('%' + testCampaign.Name + '%');
        }

        delete testCampaigns;
        undelete testCampaigns;
        // checking results - all public groups should be created again, expected result is 40 in this case
        Integer actualResult = [SELECT COUNT() FROM Group WHERE Name LIKE :campaignsNames];
        System.assertEquals(40, actualResult);
    }
}
