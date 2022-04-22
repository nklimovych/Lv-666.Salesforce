/**
 * contains methods with Voting Campaign object
 */ 
public with sharing class VotingCampaignUtil {
    //array of roles
    private final String[] ROLES = new String[]{'-Moderators', '-Analysts', '-Voters', '-Configurators'};
    /**
     * @description creates public groups for any voting campaign inserted
     * @param  newCampeigns list of inserted campaigns
     * @return list of created public groups
     */ 
    public List<Group> createGroupsAfterCreateCampaign(List<Voting_Campaign__c> newCampeigns){
        List<Group> groups = new List<Group>();      
        for(String role:ROLES){
            for (Voting_Campaign__c newCampaign : newCampeigns) {
                groups.add(new Group(Name = 'CMP-' + newCampaign.Name + role));
            }
        }
        insert groups;
        return groups;
    }  
    /**
     * @description deletes public groups for any campaign deleted
     * @param  oldCampeigns list of deleted campaigns
     */ 
    public void deleteGroupsAfterDeleteCampaign(List<Voting_Campaign__c> oldCampeigns){
        List<String> names = new List<String>();
        for(String role:ROLES){
            for (Voting_Campaign__c oldCampeign : oldCampeigns) {
                names.add('CMP-'+oldCampeign.name+role);
            }    
        }
        delete [SELECT Name FROM Group WHERE Name IN :names ];
    }
}
