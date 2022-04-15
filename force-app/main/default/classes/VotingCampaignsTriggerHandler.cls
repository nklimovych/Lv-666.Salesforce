public with sharing class VotingCampaignsTriggerHandler extends CustomMDTTriggerHandler{
    
    public override void afterInsert(){
        UserUtils.insertUser(
            GroupsManipulation.createGroupsAfterCreatingCampaign(Trigger.new)
        );
    }

    public override void afterDelete(){
        DeletingGroups.deleteGroups(Trigger.old);
    }
}