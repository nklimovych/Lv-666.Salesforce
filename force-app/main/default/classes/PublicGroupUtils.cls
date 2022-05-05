/**
 * Used to create or delete public groups
 * depends on trigger which is 
 */
public with sharing class PublicGroupUtils {
    private static final Set<String> GROUP_ROLES = new Set<String>{
        'Moderators',
        'Analysts',
        'Voters',
        'Configurators'
    };

    
    /**
     * Method uses after creating companies. Method created 4 public groups for each role of user
     * @param newRecords these are created companies
     * @return groupsToInsert this returns groups to be filtered
     */
    public static List<Group> createGroupsAfterCreatingCampaign(List<Voting_Campaign__c> newRecords){
        List<Group> groupsToInsert = new List<Group>();
        for(Voting_Campaign__c campaign: newRecords){
            for(String role: GROUP_ROLES){        
                groupsToInsert.add(new Group(
                        Name = 'CMP-' + campaign.NumberOfCampaign__c + '-' + role
                    )
                );
            }
        }
        
        insert groupsToInsert;

        return groupsToInsert;
        
    }

    /**
     * Method filters created recently public groups
     * @param createdPublicGroups This is list of recently created groups, which we will filter
     * @return configuratorGroupsId This is ids of configurator groups
     */
    public static Set<Id> getConfiguratorGroupIds(List<Group> createdPublicGroups){
        Set<Id> configuratorGroupsId = new Set<Id>();
        for(Group tempGroup: createdPublicGroups){
            if(tempGroup?.Name.contains('Configurators')){
                configuratorGroupsId.add(
                    tempGroup.Id
                );
            }
        }
        return configuratorGroupsId;
    }


    /**
     * Method uses to delete public groups after campaign after deleting the company
     * @param deletedCampaigns these are companies that have been deleted 
     */
    public static void deleteGroups(List<Voting_Campaign__c> deletedCampaigns){
        List<String> groupsToDelete = new List<String>();
        for(Voting_Campaign__c campaign: deletedCampaigns){
            for(String role: GROUP_ROLES){
                groupsToDelete.add('CMP-' +campaign.NumberOfCampaign__c +'-' + role);
            }
        } 
        
        try{
        delete [SELECT Name FROM Group WHERE Name IN :groupsToDelete];
        }catch(DmlException e){
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }       
    
}
