public with sharing class VotingCampaignsTriggerHandler extends CustomMDTTriggerHandler{
    
    public override void afterInsert(){
        UserUtils.insertUser(
            PublicGroupUtils.createGroupsAfterCreatingCampaign(Trigger.new)
        );
    }

    public override void afterDelete(){
        PublicGroupUtils.deleteGroups(Trigger.old);
    }
}