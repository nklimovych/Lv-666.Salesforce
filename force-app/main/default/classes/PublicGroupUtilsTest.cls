@isTest
private class PublicGroupUtilsTest {
    
    @testSetup static void setup(){
        List<Group> groupsList = new List<Group>();
        groupsList.add(new Group(Name='CMP-00013-Configurators'));
        groupsList.add(new Group(Name='CMP-00013-Analyst'));
        groupsList.add(new Group(Name='CMP-00013-Voters'));
        groupsList.add(new Group(Name='CMP-00013-Moderators'));
        
        insert groupsList;

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
    
    
    @isTest
    static void createGroupsAfterCreatingCampaign(){
        Voting_Campaign__c campaignForTest = [SELECT NumberOfCampaign__c
                FROM Voting_Campaign__c
                WHERE NAME = 'Test'
                LIMIT 1
            ];
        List<Group> expectedGroups = [SELECT Name 
            FROM Group 
            WHERE Name 
            Like :'%'+campaignForTest.NumberOfCampaign__c+'%'
        ];
        
        System.assertEquals(4, expectedGroups.size());

    }
    
    @isTest
    static void deleteGroups(){
        List<Group> testGroups = [SELECT Name 
            FROM Group 
            WHERE Name 
            Like :'%00013%'
        ];
        delete testGroups;
        List<Group> expectedGroup = [SELECT Name FROM Group WHERE Name LIKE :'%00013%']; 
        System.assertEquals(0, expectedGroup.size());
    }
}
