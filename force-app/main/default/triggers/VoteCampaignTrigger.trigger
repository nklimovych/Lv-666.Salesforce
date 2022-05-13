/*
* This trigger invoke the trigger handlers manager if VoteCampaign__c object record was inserted 
* (trigger event - after insert)
*/
trigger VoteCampaignTrigger on VoteCampaign__c (after insert) {
    new CustomMDTTriggerHandler().run();
}