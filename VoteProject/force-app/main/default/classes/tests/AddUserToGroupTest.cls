@isTest
public with sharing class AddUserToGroupTest {

    @TestSetup
    /**
     * This method creates five (<-- any number) different test campaigns for further 
     * use in assignment test
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
         * Unit test for method which assigns creator of campaign as a member of 
         * public group 'Configurator'
         */
    @isTest static void testAssignmentUserToGroup() {
        List<Campaign__c> testCampaignsId = [SELECT ID, Campaign_Number__c FROM Campaign__c
                                             WHERE Name LIKE 'TestCampaign_%'];
        List<String> filteredCampaigns = new List<String>();
        for(Campaign__c c: testCampaignsId){
            filteredCampaigns.add('%' + c.Campaign_Number__c + '%');
        }
        List<Group> testGroups = [SELECT Id FROM Group WHERE Name LIKE :filteredCampaigns];
        Integer countGroups = [SELECT COUNT() FROM GroupMember WHERE GroupId in :testGroups];
        System.assertEquals(5, countGroups);
    }
}
