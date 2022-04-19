public with sharing class VotingCampaignTriggerHandler extends CustomMDTTriggerHandler{
    public List<Campaign__c> newCampaings = new List<Campaign__c>();
    public List<Campaign__c> oldCampaings = new List<Campaign__c>();

    public votingCampaignTriggerHandler(List<Campaign__c> newCampaings, List<Campaign__c> oldCampaings) {
        this.newCampaings = newCampaings;
        this.oldCampaings = oldCampaings;
    }

    public campaignTriggerHandler(){
        this((List<Campaign__c>)Trigger.new, (List<Campaign__c>)Trigger.old);
    }
    public override void afterInsert(){
        for(Campaign__c cr : newCampaings){
            CreateGroups.createUserGroups(cr);
        }
    }
    public override void afterDelete(){
        for(Campaign__c del : oldCampaings){
            CreateGroups.deleteUserGroups(del);
        }
    }
}

// варто передивитись як в макса і внести корективи, не факт що це запрацює, була помилка в 5 рядку!!