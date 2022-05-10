trigger VoteCampaignLocationTrigger on VoteCampaignLocation__c (after insert, after update) {
    new CustomMDTTriggerHandler().run();
}