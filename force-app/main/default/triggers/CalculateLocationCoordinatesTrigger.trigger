/**
 * Creating instance for trigger handling
 */
trigger CalculateLocationCoordinatesTrigger on Voting_Location__c (after insert, after update) {
    new CustomMDTTriggerHandler().run();
}