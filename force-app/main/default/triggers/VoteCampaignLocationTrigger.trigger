/*
* This trigger invoke the trigger handlers manager if VoteCampaignLocation__c object record was inserted
* or the distinct address field were updated (trigger events - after insert, after update)
*/
trigger VoteCampaignLocationTrigger on VoteCampaignLocation__c (after insert, after update) {
    new CustomMDTTriggerHandler().run();
}