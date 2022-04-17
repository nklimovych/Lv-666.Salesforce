@isTest
private class PublicGroupUtilsTest {
    static testMethod void createGroupsAfterCreatingCampaign(){
        List<Voting_Campaign__c> lstCampaigns = PublicGroupUtilsTest.getCampaigns();
        System.debug(lstCampaigns);
        insert lstCampaigns;
        
        List<Voting_Campaign__c> c = [SELECT NumberOfCampaign__c FROM Voting_Campaign__c WHERE Name='test'];

        List<Group> expectedGroups = new List<Group>();
            expectedGroups.add(new Group(Name = 'CMP-' + c.get(0).NumberOfCampaign__c +'-Moderators'));
            expectedGroups.add(new Group(Name = 'CMP-' + c.get(0).NumberOfCampaign__c +'-Analysts'));
            expectedGroups.add(new Group(Name = 'CMP-' + c.get(0).NumberOfCampaign__c +'-Voters'));
            expectedGroups.add(new Group(Name = 'CMP-' + c.get(0).NumberOfCampaign__c +'-Configurators'));
        
        System.debug(expectedGroups);
        List<Group> actualGroups = [SELECT Name 
                                    FROM GROUP 
                                    WHERE Name 
                                    LIKE :lstCampaigns.get(0).NumberOfCampaign__c];
        
        System.assertEquals(expectedGroups, actualGroups);

    } 

    private static List<Voting_Campaign__c> getCampaigns(){
        List<Voting_Campaign__c> campaignsList = new List<Voting_Campaign__c>();
        Id recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Online' LIMIT 1].Id;
        campaignsList.add(new Voting_Campaign__c(
                            RecordTypeId=recordTypeId, 
                            Name='Test', 
                            Voting_Start_Date__c = Date.today(), 
                            Voting_Status__c = 'New')); 
        

        return campaignsList;
    }
}
