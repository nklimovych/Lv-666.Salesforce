public with sharing class InsertDeleteUsersInPublicGroupsTH extends CustomMDTTriggerHandler{
    public override void afterInsert(){
        Set<Id> createdUserCampaignRoleIds = new Set<Id>();
        for(User_Campain_Role__c currUserCampaignRole:(List<User_Campain_Role__c>) Trigger.New){
            createdUserCampaignRoleIds.add(
                    currUserCampaignRole.Id
                );
            }
        System.debug('Executing future method');
        System.debug(createdUserCampaignRoleIds);
        VotingCampaignRoleUtils.insertUsersToPublicGroup(createdUserCampaignRoleIds);
    }

    public override void beforeDelete() {
        System.enqueueJob(new VotingCampaignRoleUtils(Trigger.Old));
    }
}
