/**
 * This class implements asynchronous Apex processes by using the Queueable interface.
 * In this way, Apex job runs in the background in its own thread and doesn't delay 
 * the execution of main logic.
 */
public with sharing class AddUserToGroup implements Queueable {

    private List<Group> newGroups;
    private final String configuratorRole = 'Configurator';
    private String userId = userInfo.getUserId();

    /**
     * Class constructor
     * @param  addedGroups The list of groups related to 'Campaign' object
     */
    public AddUserToGroup(List<Group> addedGroups) {
        this.newGroups = addedGroups;
    }

    /**
     * This method assigns creator of campaign as a member of public group 'Configurator'
     * @param  context The parameter which contains the job ID. Type: 'QueueableContext'
     */
    public void execute(QueueableContext context) {
        List<GroupMember> members = new List<GroupMember>();
        for (Group g : newGroups) {
            GroupMember member = new GroupMember();
            if(g?.name?.contains(configuratorRole)){
                member.groupId = g.Id;
                member.userOrGroupId = userId;
                members.add(member);
            }
        }
        try {
            insert members;
        } catch (Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
}
