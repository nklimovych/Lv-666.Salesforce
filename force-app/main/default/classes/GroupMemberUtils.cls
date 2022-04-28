/*
* This is class for inserting user in configurator public group after its creation
*/
public with sharing class GroupMemberUtils implements Queueable{
    
    public Set<Id> configuratorGroupsId = new Set<Id>();

    public GroupMemberUtils(Set<Id> groupsIdList){
        this.configuratorGroupsId = groupsIdList;
    }

    /**
     * This asynchronous method inserts configurator user in public group
     * which is created recently  
     */
    public void execute(QueueableContext context){
        List<GroupMember> usersToBeInserted = new List<GroupMember>();
        for(Id groupId: configuratorGroupsId){
            usersToBeInserted.add(
                new GroupMember(
                    GroupId = groupId,
                    UserOrGroupId = UserInfo.getUserId()
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