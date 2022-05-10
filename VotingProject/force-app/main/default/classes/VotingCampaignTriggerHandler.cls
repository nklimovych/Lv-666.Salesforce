/*
    Apex Class Name:  VotingCampaignTriggerHandler
    @description:  This class is designed for handling logic processes
                   after the VotingCampaignTrigger fired
*/
public with sharing class VotingCampaignTriggerHandler extends CustomMDTTriggerHandler{
    public List<Voting_Campaign__c> newCampaigns = new List<Voting_Campaign__c>();
    public List<Voting_Campaign__c> oldCampaigns = new List<Voting_Campaign__c>();

/*
    @description:  Constructor with arguments for VC_PublicGroupsUtilities class methods
    @param newCampaigns  List of new VotingCampaign object records
    @param oldCampaigns  List of deleted VotingCampaign object records
*/
    public VotingCampaignTriggerHandler(List<Voting_Campaign__c> newCampaigns, List<Voting_Campaign__c> oldCampaigns){
        this.newCampaigns = newCampaigns;
        this.oldCampaigns = oldCampaigns;
    }

    // Default constructor
    public VotingCampaignTriggerHandler() {
        this((List<Voting_Campaign__c>)Trigger.new, (List<Voting_Campaign__c>)Trigger.old);
    }

    // Invokes method that create public groups after campaign creation
    public override void afterInsert(){
        VC_PublicGroupsUtilities.createPublicGroups(Trigger.new);
    }

    // Invokes method that delete public groups after campaign deleting
    public override void afterDelete(){
        VC_PublicGroupsUtilities.deletePublicGroups(Trigger.old);
    }

    // Invokes method that create public groups after campaign restoring
    public override void afterUndelete(){
        VC_PublicGroupsUtilities.createPublicGroups(Trigger.new);
    }
}