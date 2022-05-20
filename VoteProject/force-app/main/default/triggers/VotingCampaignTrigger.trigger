trigger VotingCampaignTrigger on Campaign__c (after insert, after delete) {
    new CustomMDTTriggerHandler().run();
}
