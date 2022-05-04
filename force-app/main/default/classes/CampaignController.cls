/**
 * class to control getting moderator for campaigns
 */ 
public with sharing class CampaignController {
    /**
     * @description method to get list of moders for campaign(from public groups)
     * @param  cmpId - id of campaign to get moders
     * @return list of moders(Lastname and Firstname)
     */ 
    @AuraEnabled(cacheable=true)
    public static List<User> getModertators(ID cmpId) {
        System.debug(cmpId);
        Voting_Campaign__c vc = [SELECT ID, Voting_Campaign_Number__c FROM Voting_Campaign__c WHERE ID = :cmpId LIMIT 1];
        String filter = '%' + vc.Voting_Campaign_Number__c + '-MODER';
        Set<ID> groupsId = (new Map<ID, SObject>([SELECT Id FROM Group WHERE Name LIKE :filter]).keySet());
        return [
            SELECT LastName, FirstName
            FROM User
            WHERE ID IN (SELECT UserOrGroupId 
                         FROM GroupMember 
                         WHERE GroupId 
                         IN :groupsId
                         )
            WITH SECURITY_ENFORCED
        ];
    }
}