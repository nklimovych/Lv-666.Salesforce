    /*
    * This class implementing trigger handler to handle logic of the VoteCampaignTrigger.
    */
public without sharing class VoteCampaignTriggerHandler extends CustomMDTTriggerHandler {
    public List<VoteCampaign__c> newCampaigns = new List<VoteCampaign__c>();
    /*
    * @description constructor that used for declare and assign list of VoteCampaigns__c sObjects (records)
    * @param list of VoteCampaigns__c sObjects (records) which created after trigger activation
    */
    public VoteCampaignTriggerHandler(List<VoteCampaign__c> newCamps) {
        this.newCampaigns = newCamps;
    }
    /*
    * @description constructor that used for catch list of VoteCampaigns__c sObjects (records) from VoteCampaignTrigger
    */
    public VoteCampaignTriggerHandler() {
        this((List<VoteCampaign__c>)Trigger.new);
    }
    /*
    * @description method that invoke public groups creation in case of trigger event afterInsert has occured,
    and passes as an argument list of VoteCampaign__c sObjects
    */
    public override void afterInsert() {
        PublicGroupsManager.createPublicGroups(newCampaigns);
    }
}
