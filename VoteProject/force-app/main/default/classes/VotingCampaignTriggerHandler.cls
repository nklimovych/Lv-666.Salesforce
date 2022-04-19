public with sharing class VotingCampaignTriggerHandler extends CustomMDTTriggerHandler{
    public List<Campaign__c> newCampaings = new List<Campaign__c>();
    public List<Campaign__c> oldCampaings = new List<Campaign__c>();

    public votingCampaignTriggerHandler(List<Campaign__c> nCampaings, List<Campaign__c> oCampaings) {
        this.newCampaings = nCampaings;
        this.oldCampaings = oCampaings;
    }

    public votingCampaignTriggerHandler(){
        this((List<Campaign__c>)Trigger.new, (List<Campaign__c>)Trigger.old);
    }

    public override void afterInsert(){
        System.enqueueJob(new AddUserToGroup(CreateGroups.createUserGroups(newCampaings)));
    }

    public override void afterDelete(){
        CreateGroups.deleteUserGroups(oldCampaings);
        System.debug('afterDelete');
    }
}
