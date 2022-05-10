/*
    @description: This trigger fires after VotingCampaign object
                  records are created, deleted or undeleted
*/
trigger VotingCampaignTrigger on Voting_Campaign__c (after insert, before delete, after delete, after undelete) {
    new CustomMDTTriggerHandler().run();
}