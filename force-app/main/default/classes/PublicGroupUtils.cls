public with sharing class PublicGroupUtils {
    private static final Set<String> GROUP_ROLES = new Set<String>{
        'Moderators',
        'Analysts',
        'Voters',
        'Configurators'
    };


    // Method creates 4 public groups linked to created campaign
    // Works only after insert new campaign 
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

    // Filtrating created public groups which name include string 'Configurator'
    public static Set<Id> getConfiguratorGroupIds(List<Group> configuratorGroups){
        Set<Id> configuratorGroupsId = new Set<Id>();
        for(Group tempGroup: configuratorGroups){
            if(tempGroup?.Name.contains('Configurators')){
            
                configuratorGroupsId.add(
                tempGroup.Id
                );
            
            }
        }
        return configuratorGroupsId;
    }


    // !*Method deletes public groups linked to campaign which is deleted*!
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
