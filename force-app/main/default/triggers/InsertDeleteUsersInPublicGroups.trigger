trigger InsertDeleteUsersInPublicGroups on User_Campain_Role__c (after insert, after delete, before delete) {
    new CustomMDTTriggerHandler().run();
}