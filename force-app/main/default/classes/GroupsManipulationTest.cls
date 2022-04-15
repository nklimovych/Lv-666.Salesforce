@isTest
private class GroupsManipulationTest {
    static testMethod void createGroupsAfterCreatingCampaign(){
        Test.startTest();
        GroupsManipulation.createGroupsAfterCreatingCampaign(getCampaigns());
        Test.stopTest();
        List<String> check = new List<String>();
        for(Voting_Campaign__c campaign: getCampaigns()){
            check.add(campaign.NumberOfCampaign__c);
        }
        System.debug(check);
        List<Group> createdGroups = [SELECT Name FROM Group];
        System.debug('groups: ' + createdGroups);
        for(String name: check){
            for(Group currGroup: createdGroups){
                System.assert(currGroup.Name.contains(name), 'should be true');
            }
        }
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
