public with sharing class VotingCampaignController {

    public static List<Group> createGroupsAfterCreateCampaign(List<Voting_Campaign__c> newCampeigns){
        String[] roles = new String[]{'-Moderators', '-Analysts', '-Voters', '-Configurators'};
        List<Group> groups = new List<Group>();      
        for(String role:roles){
            for (Voting_Campaign__c newCampaign : newCampeigns) {
                groups.add(new Group(Name = 'CMP-' + newCampaign.Name + role));
            }
        }
        insert groups;
        return groups;
    }  
    
    public static void deleteGroupsAfterDeleteCampaign(Voting_Campaign__c oldCampeign){
        String name = 'CMP-'+oldCampeign.name+'%';
        delete [SELECT Name FROM Group WHERE Name LIKE :name ];
    }
}
