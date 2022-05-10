/*
    Apex Class Name:  VC_PublicGroupsUtilities
                      (Namespace "VC" stands for Voting Campaign)
    @description: This class is designed for creating/deleting public groups for each
                  voting campaign user role after campaign creation/deletion
*/
public with sharing class VC_PublicGroupsUtilities {
    // Set of VC user roles
    private static final Set<String> USER_ROLES = new Set<String>{
        'Configurators',
        'Moderators',
        'Analysts',
        'Voters'
    };

/*
    @description: This method is designed for creating 4 public groups for each new campaign
    @param newCampaigns The list of created campaigns
*/
    public static void createPublicGroups(List<Voting_Campaign__c> newCampaigns){
        // Forming groups with the necessary name template
        List<Group> groupsToBeCreated = new List<Group>();
        for(Voting_Campaign__c newCampaign :newCampaigns){
            for(String userRole :USER_ROLES){
                groupsToBeCreated.add(new Group(Name = 'CMP-' + newCampaign.Name + '-' + userRole));
            }
        }
        try {
            insert groupsToBeCreated;
        } 
        catch(DmlException e){
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        // Invokes method for adding user to public group as configurator
        VC_MembersUtilities_Queueble addConfigurator = new VC_MembersUtilities_Queueble(groupsToBeCreated);
        System.enqueueJob(addConfigurator);
    }

/*
    @description: This method is designed for deleting public groups after campaign deletion
    @param oldCampaigns The list of deleted campaigns
*/
    public static void deletePublicGroups(List<Voting_Campaign__c> oldCampaigns){
        // Retrieving names of deleted campaigns
        List<String> oldCampaignsNames = new List<String>();
        for(Voting_Campaign__c oldCampaign :oldCampaigns){
            oldCampaignsNames.add('%' + oldCampaign.Name + '%');
        }
        // Filtering groups according to the deleted campaign names
        List<Group> groupsToBeDeleted = [SELECT ID FROM Group WHERE Name LIKE :oldCampaignsNames];
        
        try {
            delete groupsToBeDeleted;
        } 
        catch(QueryException queryE) {
            System.debug('The following exception has occurred: ' + queryE.getMessage());
        } 
        catch(DmlException dmlE){
            System.debug('The following exception has occurred: ' + dmlE.getMessage());
        }
    }
}
