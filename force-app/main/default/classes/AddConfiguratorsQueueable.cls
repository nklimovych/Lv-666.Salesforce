/**
 * queueable class which implements asynchronous jobs for adding group member to group
 */
public with sharing class AddConfiguratorsQueueable implements Queueable {

    private List<Group> newGroups;
    /**
     * @description constructor 
     * @param  addedGroups - list of groups related to Voting Campaign object
     */ 
    public AddConfiguratorsQueueable(List<Group> addedGroups) {
        this.newGroups = addedGroups;
    }
    /**
     * @description assigns creator of campaign as a public confugurators group member
     * @param  context
     */ 
    public void execute(QueueableContext context){
        List<GroupMember> members = new List<GroupMember>();
        for (Group g : newGroups) {
            GroupMember member = new GroupMember();
            if(g.name.contains('Configurators')){
                member.GroupId = g.Id;
                member.UserOrGroupId = UserInfo.getUserId();
                members.add(member);
            }            
        }   
        try {
            insert members;
    
        } catch (Exception e) {
            System.enqueueJob(new ExceptionUtility(e));
        }   
    }
}
