public with sharing class PublicGroupUtils {
    private static final Set<String> GROUP_ROLES = new Set<String>{
        'Moderators',
        'Analysts',
        'Voters',
        'Configurators'
    };

    public static Set<Id> createGroupsAfterCreatingCampaign(List<Voting_Campaign__c> newRecords){
        List<Group> groupsToInsert = new List<Group>();
        List<Group> configuratorGroups = new List<Group>();
        for(Voting_Campaign__c campaign: newRecords){
            for(String role: GROUP_ROLES){
                Group tempGroup = new Group(
                    Name = 'CMP-' + campaign.NumberOfCampaign__c + '-' + role
                    );

                groupsToInsert.add(tempGroup);

                if(role == 'Configurators'){
                    configuratorGroups.add(tempGroup);
                }
            }
        }
        try{
        insert groupsToInsert;
        } catch(DmlException e){
            System.debug('The following exception has occurred: ' + e.getMessage());
        }


        Set<Id> configuratorGroupsId = new Set<Id>();
        for(Group configuratorGroup: configuratorGroups){
            configuratorGroupsId.add(configuratorGroup.Id);
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
