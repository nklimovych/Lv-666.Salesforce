@isTest
public with sharing class AddConfiguratorsQueueableTest {
    /**
     * @description setup description
     */ 
    @TestSetup
    static void setup(){
        //creating and inserting initial list of campaigns
        List<Voting_Campaign__c> campaigns = new List<Voting_Campaign__c>();
        //20 items to check bulk insert
        for(Integer i = 0; i < 20; i++){
            campaigns.add(new Voting_Campaign__c(Campaign_Name__c='Test' + i));
        }
        Test.startTest();
        insert campaigns;
        Test.stopTest();
    }
    /**
     * @description test metod for AddConfiguratorsQueueable class
     */
    @isTest
    static void configuratorsAssignmentTest(){
        //creating list of names for test groups
        List<String> nameOfGroups = new List<String>();
        for(Voting_Campaign__c campaign :[SELECT Name FROM Voting_Campaign__c WHERE Campaign_Name__c LIKE 'Test%' ]){
            nameOfGroups.add('CMP-' + campaign.Name + '-Configurators');
        }
        //creating list of test groups of configurator
        List<Group> groups = [SELECT Id FROM Group WHERE Name IN :nameOfGroups];
        //creating list of Id for test groups of configurator
        List<Id> groupsId = new List<Id>();
        for (Group g: groups) {
            groupsId.add(g.Id);
        }
        //finding number of group member in test groups of configurator
        Integer numberOfGroupMember = [SELECT COUNT() FROM GroupMember WHERE GroupId in :groupsId];
        System.assertEquals(20, numberOfGroupMember);
    }
}
