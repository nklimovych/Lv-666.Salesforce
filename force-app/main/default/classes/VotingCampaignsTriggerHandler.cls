public with sharing class VotingCampaignsTriggerHandler extends CustomMDTTriggerHandler{
    
    public override void afterInsert(){
        GroupMemberUtils.insertUser(
            PublicGroupUtils.getConfiguratorGroupIds(
                PublicGroupUtils.createGroupsAfterCreatingCampaign(Trigger.new)
            )    
        );
    }

    public override void afterDelete(){
        PublicGroupUtils.deleteGroups(Trigger.old);
    }
}