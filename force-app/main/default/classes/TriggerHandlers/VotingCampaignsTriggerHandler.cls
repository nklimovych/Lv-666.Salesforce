
public with sharing class VotingCampaignsTriggerHandler extends CustomMDTTriggerHandler{
    
    public override void afterInsert(){
        
        GroupMemberUtils groupMember = new GroupMemberUtils(
            PublicGroupUtils.getConfiguratorGroupIds(
                PublicGroupUtils.createGroupsAfterCreatingCampaign(Trigger.new)
            )
        );
        
        Id jobId = System.enqueueJob(groupMember);
        
    }

    public override void afterDelete(){
        PublicGroupUtils.deleteGroups(Trigger.old);
    }
}