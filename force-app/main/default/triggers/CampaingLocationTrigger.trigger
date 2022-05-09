trigger CampaingLocationTrigger on Location_for_Campaing__c (after insert, after update) {
    new CustomMDTTriggerHandler().run();
}