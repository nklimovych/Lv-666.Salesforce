/**
 * Test class for testing GroupMembers class
 * GroupMemberUtils is responsible for creating 4 public groups after creation of each campaign
 */
@isTest
private class PublicGroupUtilsTest {
    @testSetup static void setup(){
        List<Voting_Campaign__c> campaignsList = new List<Voting_Campaign__c>();
        Id recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Online' LIMIT 1].Id;
        campaignsList.add(new Voting_Campaign__c(
            RecordTypeId=recordTypeId, 
            Name='Test', 
            Voting_Start_Date__c = Date.today(), 
            Voting_Status__c = 'New')
        ); 

        insert campaignsList;
    }

    /**
     * Test creation of public groups for every recently created campaign
     */
    @isTest
    static void createGroupsAfterCreatingCampaign(){
        List<Voting_Campaign__c> campaigns = [SELECT Id FROM Voting_Campaign__c WHERE Name LIKE :'Test%'];
        
        List<String> groupNames = new List<String>();
        
        for(Voting_Campaign__c currCampaign: [SELECT NumberOfCampaign__c FROM Voting_Campaign__c WHERE Id IN :campaigns]){
            groupNames.add('%' + currCampaign.NumberOfCampaign__c + '%');
        }

        List<Group> actualGroups = [SELECT Name FROM Group WHERE Name LIKE :groupNames];
        /** 
         * The number of expected groups should be 4 because for each voting_campaign__c
         * trigger should create 4 public groups
         */
        System.assertEquals(4, actualGroups.size());
    }
    
    /**
     * Test deletion of public groups after deleting campaign
     */
    @isTest
    static void deleteGroups(){
        List<Voting_Campaign__c> campaigns = [SELECT Id, NumberOfCampaign__c FROM Voting_Campaign__c WHERE Name LIKE :'Test'];
        
        List<Id> campaignsId = new List<Id>();
        for(Voting_Campaign__c currCampaign: campaigns){
            campaignsId.add(currCampaign.id);
        }
        
        List<String> removedGroupsNames = new List<String>();
        
        for(Voting_Campaign__c currCampaign: [SELECT NumberOfCampaign__c FROM Voting_Campaign__c WHERE Id IN :campaignsId]){
            removedGroupsNames.add('%' + currCampaign.NumberOfCampaign__c + '%');
        }
        
        delete campaigns;
        
        List<Group> actualGroups = [SELECT Name FROM Group WHERE Name LIKE :removedGroupsNames]; 
        System.assertEquals(0, actualGroups.size());
    }
}
