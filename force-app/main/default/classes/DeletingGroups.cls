public with sharing class DeletingGroups{
    public static void deleteGroups(List<Voting_Campaign__c> deletedCampaigns){
        Set<String> roles = new Set<String>{
            'Moderators',
            'Analysts',
            'Voters',
            'Configurators'
        };
        List<String> groupsToSelect = new List<String>();
        for(Voting_Campaign__c campaign: deletedCampaigns){
            for(String role: roles){
                groupsToSelect.add('CMP-' +campaign.NumberOfCampaign__c +'-' +role);
            }
        }
        List<Group> groupsToBeDeleted = [SELECT Name FROM Group WHERE Name IN :groupsToSelect];
        delete groupsToBeDeleted;
    }       
}

