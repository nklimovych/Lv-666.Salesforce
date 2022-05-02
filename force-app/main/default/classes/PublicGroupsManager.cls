/*
* Class that manages actions with the Group object  (for instance - create public groups)
*/
public without sharing class PublicGroupsManager {
    /*
    * @description default class constructor with commented debug "start" message
    */
    public PublicGroupsManager() {
        //System.debug('PublicGroupsManager started...');
    }
    /*
    * @description method that invoke apex queueble job for create appropriate public groups.
    * Commented rows contains code for apex queueble job debugging
    * @param list of VoteCampaign__c sObjects
    */
    public static void createPublicGroups(List<VoteCampaign__c> newcampaigns) {
        System.debug('createPublicGroups method started...');
        CreatePublicGroups creategroupsjob = new CreatePublicGroups(newcampaigns);
        ID creategroupsjobid = System.enqueueJob(creategroupsjob);
        //AsyncApexJob creategroupsjob_log = [SELECT Id, Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :creategroupsjobid];
        //System.debug('Create groups job log: ' + creategroupsjob_log);
    }
}
