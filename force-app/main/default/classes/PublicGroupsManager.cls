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
    * @param list of VoteCampaign__c sObjects
    */
    public static void createPublicGroups(List<VoteCampaign__c> newCampaigns) {
    System.enqueueJob(new CreatePublicGroups(newCampaigns));
    }
}
