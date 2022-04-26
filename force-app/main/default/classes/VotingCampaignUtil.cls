/**
 * contains methods with Voting Campaign object
 */ 
public with sharing class VotingCampaignUtil {
    //array of roles
    private final List<String> ROLES = new List<String>{'-Moderators', '-Analysts', '-Voters', '-Configurators'};
    /**
     * @description creates public groups for any voting campaign inserted
     * @param  newCampeigns list of inserted campaigns
     * @return list of created public groups
     */ 
    public List<Group> createGroupsAfterCreateCampaign(List<Voting_Campaign__c> newCampeigns){
        List<Group> groups = new List<Group>();      
        for(String name:namesOfGroups(newCampeigns)){            
            groups.add(new Group(Name = name));            
        }
        insert groups;
        return groups;
    }  
    /**
     * @description deletes public groups for any campaign deleted
     * @param  oldCampeigns list of deleted campaigns
     */ 
    public void deleteGroupsAfterDeleteCampaign(List<Voting_Campaign__c> oldCampeigns){
        List<String> names = namesOfGroups(oldCampeigns);
        delete [SELECT Name FROM Group WHERE Name IN :names ];
    }
    /**
     * @description creates list of names for public groups
     * @param  campeigns list of campaigns
     * @return list of names for public groups
     */
    public List<String> namesOfGroups(List<Voting_Campaign__c> campeigns){
        List<String> names = new List<String>();
        for(String role:ROLES){
            for (Voting_Campaign__c campeign : campeigns) {
                names.add('CMP-'+campeign.name+role);
            }    
        }
        return names;
    }
}
