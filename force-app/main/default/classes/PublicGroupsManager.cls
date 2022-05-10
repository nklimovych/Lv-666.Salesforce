/*
* Class that manages actions with the Group object  (for instance - create public groups)
*/
public without sharing class PublicGroupsManager {
    /*
    * @description default class constructor
    */
    public PublicGroupsManager() {
    }
    /*
    * @description method that invoke apex queueble job for create appropriate public groups.
    * Commented rows contains code for apex queueble job debugging
    * @param list of VoteCampaign__c sObjects
    */
    public static void createPublicGroups(List<VoteCampaign__c> newCampaigns) {
        CreatePublicGroups createGroupsJob = new CreatePublicGroups(newCampaigns);
        ID createGroupsJobId = System.enqueueJob(createGroupsJob);
        //AsyncApexJob createGroupsJob_Log = [SELECT Id, Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :createGroupsJobId];
        //System.debug('Create groups job log: ' + createGroupsJob_Log);
    }
}
