/**
 * @description Class which controls rigger on Voting_Campaign__c object
 */
public with sharing class VotingCampaignsTriggerHandler extends CustomMDTTriggerHandler{
    /**
     * @description Creates 4 public groups for every campaign
     */
    public override void afterInsert() {
        
        GroupMemberUtils groupMember = new GroupMemberUtils(
            PublicGroupUtils.getConfiguratorGroupIds(
                PublicGroupUtils.createGroupsAfterCreatingCampaign(Trigger.new)
            )
        );
        /**
         * Аsynchronously adds configurator user in configurator's public groups 
         */       
        Id jobId = System.enqueueJob(groupMember);
        
    }

    /**
     * @description Deletes public groups which belong to deleted campaigns
     */
    public override void afterDelete(){
        PublicGroupUtils.deleteGroups(
            Trigger.Old
        );
    }
}