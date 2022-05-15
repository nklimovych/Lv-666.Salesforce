/**
 * @description trigger on Voting Campaign object
 * @param  insert - some tasks after insert
 * @param  delete - some tasks before delete
 */
trigger VotingCampaignTrigger on Voting_Campaign__c (after insert, before delete) {
    new CustomMDTTriggerHandler().run();
}