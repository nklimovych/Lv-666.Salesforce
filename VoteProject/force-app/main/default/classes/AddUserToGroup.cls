public with sharing class AddUserToGroup implements Queueable {

    private List<Group> newGroups;
	private final String CONF = 'Configurator';
        
    public AddUserToGroup(List<Group> addedGroups) {
        this.newGroups = addedGroups;
    }

    public void execute(QueueableContext context){
        List<GroupMember> members = new List<GroupMember>();
        for (Group g : newGroups) {
            GroupMember member = new GroupMember();
            if(g?.name?.contains(CONF)){
                member.groupId = g.Id;
                member.userOrGroupId = userInfo.getUserId();
                members.add(member);
            }
        }
        insert members;
    }
}
