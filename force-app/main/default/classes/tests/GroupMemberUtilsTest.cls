/**
 * Test of PublicGroupUtils class which is responsible for assignment of configurator user in configurator public group
 */
@isTest
public with sharing class GroupMemberUtilsTest {
    @TestSetup
    static void setup(){
        List<Voting_Campaign__c> campaignsList = new List<Voting_Campaign__c>();
        Id recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Online' LIMIT 1].Id;

        campaignsList.add(new Voting_Campaign__c(
                RecordTypeId=recordTypeId, 
                Name='Test', 
                Voting_Start_Date__c = Date.today(), 
                Voting_Status__c = 'New'
            )
        );
        insert campaignsList;
    }
    
    /**
     * Method tests inserting configurator user in 1 of 4 recently created public groups
     * This public group name should be LIKE 'Configurators'
     */
    @isTest
    static void configuratorUserAssignmentTest(){
        List<Id> campaignIds = new List<Id>();
        for(Voting_Campaign__c currCampaign: [SELECT Id FROM Voting_Campaign__c WHERE Name LIKE :'Test']){
            campaignIds.add(currCampaign.Id);
        }

        List<String> groupNames = new List<String>();
        for(Voting_Campaign__c currCampaign: [SELECT NumberOfCampaign__c FROM Voting_Campaign__c WHERE Id IN :campaignIds]){
            groupNames.add('%' + currCampaign.NumberOfCampaign__c + '%');
        }

        List<Group> createdGroups = [SELECT Id FROM Group WHERE Name LIKE :groupNames];
        List<Id> newGroupId = new List<Id>();
        for(Group currGroup: createdGroups){
            newGroupId.add(currGroup.Id);
        }

        List<GroupMember> actualGroupMembers = [SELECT GroupId FROM GroupMember WHERE GroupId IN :newGroupId];
        System.assertEquals(1, actualGroupMembers.size());
    }
}
