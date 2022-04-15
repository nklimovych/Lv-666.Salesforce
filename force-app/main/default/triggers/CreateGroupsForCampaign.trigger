trigger CreateGroupsForCampaign on Voting_Campaign__c (after insert, before delete, after delete, after undelete) {
    new CustomMDTTriggerHandler().run();
}