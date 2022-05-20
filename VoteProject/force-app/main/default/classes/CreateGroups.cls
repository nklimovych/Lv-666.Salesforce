/**
 * This Apex class is designed to create or remove four public groups (one for each user
 * role) when creating or deleting a campaign
 */
public with sharing class CreateGroups{
    public final List<String> userRoles = new List<String>{
        'Configurator',
        'Moderator',
        'Voter',
        'Analyst'};

    /**
     * This method is creating a list of group names for assigned campaign
     * @param  campaigns    The list of campaigns for which you are creating group names
     * @return              Returns a list of group names
     */
    public List<String> createGroupNames(List<Campaign__c> campaigns){
        List<String> groupNames = new List<String>();
        for (Campaign__c campaign : campaigns) {
            for (String role: userRoles) {
                groupNames.add('CMP-' + campaign.Campaign_Number__c + '-' + role);
            }
        }
        return groupNames;
    }

    /**
     * This method is creating four public groups when user is creating new campaign and
     * assign them to that campaign
     * @param  newCampaign     The list of new campaigns which were inserted
     * @return                 Returns the list of new created public groups assigned
     *                         to campaign
     */
    public List<Group> createUserGroups(List<Campaign__c> newCampaign){
        List<Group> newGroups = new List<Group>();
        List<String> groupNames = createGroupNames(newCampaign);
        for(String groupName : groupNames) {
            newGroups.add(new Group(Name = groupName));
        }

        try{
            insert newGroups;
        } catch (DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        return newGroups;
    }

    /**
     * This method is deleting all public groups when user is deleting assigned campaign
     * @param  deletedCampaign   The list of campaigns which were deleted
     */
    public void deleteUserGroups(List<Campaign__c> deletedCampaign){
        List<String> selectedGroups = createGroupNames(deletedCampaign);

        try {
            List<Group> deleteSelectedGroups = [SELECT Name FROM Group WHERE Name IN :selectedGroups];
            delete deleteSelectedGroups;
        } catch (DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
}
