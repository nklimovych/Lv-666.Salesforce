@isTest
/**
 * This Apex class is designed to test CreateGroup class which can create or remove
 * public groups when creating or deleting a campaign
 */
public with sharing class CreateGroupsTest {

    @TestSetup
    /**
     * This method creates five (<-- any number) different test campaigns for further 
     * use in creation and deletion tests
     */
    static void createTestData() {
        List<Campaign__c> campaigns = new List<Campaign__c>();
        for(Integer i=0; i<5; i++) {
            Campaign__c testCampaigns = new Campaign__c(Name='TestCampaign_' + i);
            campaigns.add(testCampaigns);
        }
        Test.startTest();
        insert campaigns;
        Test.stopTest();
    }
    
        /**
         * Unit test for method createUserGroups()
         * @param mapTestCampaignsId   Creates a new instance of the Map class and
         *                             populates it with the passed-in list of sObject
         *                             records. The keys are populated with the sObject
         *                             IDs and the values are the sObjects.
         * @param setId                Returns a set that contains all of the unique 
         *                             campaign IDs in the map
         * @param filteredCampaigns    Filtered list of campaigns
         */
    @isTest static void testCreateGroups() {
        Map<ID, SObject> mapTestCampaignsId = new Map<ID, SObject>([SELECT Id FROM Campaign__c 
                                                                    WHERE Name LIKE 'TestCampaign_%']);
        Set<ID> setId = new Set<ID>(mapTestCampaignsId.keySet());
        List<Campaign__c> campaigns = [SELECT ID, Campaign_Number__c FROM Campaign__c WHERE ID IN :setId];
        List<String> filteredCampaigns = new List<String>();
        for(Campaign__c c :campaigns){
            filteredCampaigns.add('%' + c.Campaign_Number__c + '%');
        }
        Integer countGroups = [SELECT COUNT() FROM Group WHERE Name LIKE :filteredCampaigns];
        System.assertEquals(20, countGroups);
    }

        /**
         * Unit test for method deleteUserGroups()
         * @param mapTestCampaignsId   Creates a new instance of the Map class and
         *                             populates it with the passed-in list of sObject
         *                             records. The keys are populated with the sObject
         *                             IDs and the values are the sObjects.
         * @param setId                Returns a set that contains all of the unique 
         *                             campaign IDs in the map
         * @param filteredCampaigns    Filtered list of campaigns
         */
    @isTest static void testDeleteGroups() {
        List<Campaign__c> testCampaignsId = [SELECT Id FROM Campaign__c WHERE Name LIKE 'TestCampaign_%'];
        Map<ID, SObject> mapTestCampaignsId = new Map<ID, SObject>(testCampaignsId);
        Set<ID> setId = new Set<ID>(mapTestCampaignsId.keySet());
        List<Campaign__c> campaigns = [SELECT ID, Campaign_Number__c FROM Campaign__c WHERE ID IN :setId];
        List<String> filteredCampaigns = new List<String>();
        for(Campaign__c c :campaigns){
            filteredCampaigns.add('%' + c.Campaign_Number__c + '%');
        }
        delete testCampaignsId;
        Integer countGroups = [SELECT count() FROM Group WHERE Name LIKE :filteredCampaigns];
        System.assertEquals(0,  countGroups);
    }
}
