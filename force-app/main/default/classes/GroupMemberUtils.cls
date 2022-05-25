/*
* This is class for inserting user in configurator public group after its creation
*/
public with sharing class GroupMemberUtils implements Queueable{
    
    public Set<Id> configuratorGroupsId = new Set<Id>();
    public List<User_Campain_Role__c> userCampaignObj = new List<User_Campain_Role__c>();
    public GroupMemberUtils(Set<Id> groupsIdList){
        this.configuratorGroupsId = groupsIdList;
    }

    public GroupMemberUtils(List<User_Campain_Role__c> newRecords){
        this.userCampaignObj = newRecords;
    }

    /**
     * This asynchronous method inserts configurator user in public group
     * which is created recently  
     */
    public void execute(QueueableContext context){
        List<GroupMember> usersToBeInserted = new List<GroupMember>();
        Id currentUserId = UserInfo.getUserId();
        for(Id groupId: configuratorGroupsId){
            usersToBeInserted.add(
                new GroupMember(
                    GroupId = groupId,
                    UserOrGroupId = currentUserId
                )
            );
        }
        
        try{
            insert usersToBeInserted;
        }catch(Exception e){
            System.enqueueJob(new ExceptionUtility(e));
        }
    }
}