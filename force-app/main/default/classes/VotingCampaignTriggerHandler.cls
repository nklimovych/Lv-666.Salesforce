public with sharing class VotingCampaignTriggerHandler extends CustomMDTTriggerHandler{
    public List<Voting_Campaign__c> newCampaigns = new List<Voting_Campaign__c>();
    public List<Voting_Campaign__c> oldCampaigns = new List<Voting_Campaign__c>();

    public VotingCampaignTriggerHandler(List<Voting_Campaign__c> nCampaigns, List<Voting_Campaign__c> oCampaigns){
        this.newCampaigns = nCampaigns;
        this.oldCampaigns = oCampaigns;
    }

    public VotingCampaignTriggerHandler() {
        this((List<Voting_Campaign__c>)Trigger.New, (List<Voting_Campaign__c>)Trigger.old);

    }

    public override void afterInsert(){          
        System.enqueueJob(new AddConfiguratorsQueueable(VotingCampaignController.createGroupsAfterCreateCampaign(newCampaigns)));
    }

    public override void beforeDelete(){
        for (Voting_Campaign__c oldCampaign : oldCampaigns) {
            VotingCampaignController.deleteGroupsAfterDeleteCampaign(oldCampaign);
        }
    }

}
