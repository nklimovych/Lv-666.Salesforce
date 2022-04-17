@isTest 
private class TestPublicGroupsCreation {
    static testMethod void testCreatingGroups(){
    List<Voting_Campaign__c> campaignsList = new List<Voting_Campaign__c>();
    Id recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Online' LIMIT 1].Id;
    campaignsList.add(new Voting_Campaign__c(
                        RecordTypeId=recordTypeId, 
                        Name='Test', 
                        Voting_Start_Date__c = Date.today(), 
                        Voting_Status__c = 'New'));
    insert campaignsList;

    List<Voting_Campaign__c> c = [SELECT NumberOfCampaign__c FROM Voting_Campaign__c WHERE Name ='Test'];

    List<Group> actualGroups = [SELECT Name 
                                FROM GROUP 
                                ];
        System.debug(actualGroups);
    List<Group> expectedGroups = new List<Group>();
    expectedGroups.add(new Group(Name = 'CMP-' + c.get(0).NumberOfCampaign__c +'-Moderators'));
    expectedGroups.add(new Group(Name = 'CMP-' + c.get(0).NumberOfCampaign__c +'-Analysts'));
    expectedGroups.add(new Group(Name = 'CMP-' + c.get(0).NumberOfCampaign__c +'-Voters'));
    expectedGroups.add(new Group(Name = 'CMP-' + c.get(0).NumberOfCampaign__c +'-Configurators'));
    
    System.assertEquals(expectedGroups, actualGroups);

    }
}
