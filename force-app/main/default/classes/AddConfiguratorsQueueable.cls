public with sharing class AddConfiguratorsQueueable implements Queueable {

    private List<Group> newGroups;

    public AddConfiguratorsQueueable(List<Group> addedGroups) {
        this.newGroups = addedGroups;
    }

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
        System.debug(members);
        insert members;
    }
}
