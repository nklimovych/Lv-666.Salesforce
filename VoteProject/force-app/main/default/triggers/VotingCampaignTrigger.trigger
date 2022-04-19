trigger VotingCampaignTrigger on Campaign__c (before insert, before delete, before undelete, after insert, after delete){
    new CustomMDTTriggerHandler().run();
}