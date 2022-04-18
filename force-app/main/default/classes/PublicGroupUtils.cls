public with sharing class PublicGroupUtils {
    private static final Set<String> GROUP_ROLES = new Set<String>{
        'Moderators',
        'Analysts',
        'Voters',
        'Configurators'
    };

    public static List<Group> createGroupsAfterCreatingCampaign(List<Voting_Campaign__c> newRecords){
        List<Group> groupsToInsert = new List<Group>();
        List<Group> configuratorGroups = new List<Group>();
        for(Voting_Campaign__c campaign: newRecords){
            for(String role: GROUP_ROLES){
                
                groupsToInsert.add(new Group(
                        Name = 'CMP-' + campaign.NumberOfCampaign__c + '-' + role
                    )
                );
            
            }
        }

        try{
        insert groupsToInsert;
        } catch(DmlException e){
            System.debug('The following exception has occurred: ' + e.getMessage());
        }

        return groupsToInsert;
    }
    

    public static Set<Id> getConfiguratorGroupIds(List<Group> configuratorGroups){
        Set<Id> configuratorGroupsId = new Set<Id>();
        for(Group tempGroup: configuratorGroups){
            if(tempGroup.Name.contains('Configurators')){
            
                configuratorGroupsId.add(
                tempGroup.Id
                );
            
            }
        }
        return configuratorGroupsId;
    }

    public static void deleteGroups(List<Voting_Campaign__c> deletedCampaigns){
        List<String> groupsToSelect = new List<String>();
        for(Voting_Campaign__c campaign: deletedCampaigns){
            for(String role: GROUP_ROLES){
                groupsToSelect.add('CMP-' +campaign.NumberOfCampaign__c +'-' + role);
            }
        }
        List<Group> groupsToBeDeleted = [SELECT Name FROM Group WHERE Name IN :groupsToSelect];

        try{
        delete groupsToBeDeleted;
        }catch(DmlException e){
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }       
    
}
