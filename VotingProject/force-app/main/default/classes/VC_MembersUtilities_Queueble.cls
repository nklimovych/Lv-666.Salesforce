/*
    Apex Class Name:  VC_MembersUtilities_Queueble
                      (Namespace "VC" stands for Voting Campaign)
    @description: This class is designed to asynchronously add users who create new records on VotingCampaign
                  object to the appropriate public group as Configurators
                  and send exception notification to configurators and system admins using ExeptionUtility framework
*/
public with sharing class VC_MembersUtilities_Queueble implements Queueable {
    private List<Group> newGroups;
    /*
    @description: Constructor with ability to pass a list of new groups
    @param  newGroups
    */
    public VC_MembersUtilities_Queueble(List<Group> newGroups){
        this.newGroups = newGroups;
    }
    /*
    @description: adds configurators to public group
    @param  context
    */
    public void execute(QueueableContext context) {
        List<GroupMember> configurators = new List<GroupMember>();
        for (Group newGroup: newGroups){
            if (newGroup?.name?.contains('Configurators')){
                configurators.add(new GroupMember(GroupId=newGroup.Id, UserOrGroupId=UserInfo.GetUserId()));
            }
        }
        try{
            insert configurators;
        }
        catch(Exception e){
            // Invokes ExceptionUtility in order to send notifications to configurator and system admins
            System.enqueueJob(new ExceptionUtility(e));
        }
    }
}
