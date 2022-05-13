/*
* Class contains method that configure apex queueable job for create GroupMember object
* records related to public groups defined in list of Group sObjects
*/
public without sharing class ManagePublicGroupsMembers implements Queueable {
    private List<Group> publicGroups;
    /*
    * @description class constructor that collect list of appropriate Group sObjects from CreatePublicGroups class
    * and assign it to the publicgroups variable
    * @param list of Group sObjects from CreatePublicGroups class
    */
    public ManagePublicGroupsMembers(List<Group> newPublicGroups) {
        this.publicGroups = newPublicGroups;
    }
    /*
    * @description method that configure apex queueable job for create GroupMember object
    * records related to public groups, based on list of Group sObjects from CreatePublicGroups class, 
    * and catch the appropriate exception if inserting records was unsuccessful with displaying
    * an appropriate debug message with description about an error.
    * Also invoke sendMail method from EmailManager class that sends email notifications
    * to the users who added to the appropriate public groups as group members.
    * @param implements QueueableContext interface
    */
    public void execute(QueueableContext context) {
        try {
            List<GroupMember> groupMembers = new List<GroupMember>();
            Id userId = UserInfo.getUserId();
            String userEmail = UserInfo.getUserEmail();
            for (Group publicGroup : publicGroups) {
                GroupMember gm = new GroupMember();
                gm.GroupId = publicGroup.Id;
                gm.UserOrGroupId = userId;
                groupMembers.add(gm);
                EmailManager.sendMail(userEmail, concEmailSubj(publicGroup.Name), concEmailBody(publicGroup.Name));
            }
            insert groupMembers;

        } catch (DmlException e) {
            System.debug('An error has occurred while adding members to the public groups: ' + e.getMessage());
        }
    }
    /*
    * @description method that concatinate Subject email message with the name of the public group
    * @param name of the public group
    * @return Subject email message that concatinated with the name of the public group
    */
    public String concEmailSubj(String groupName) {
        return 'You have been added to public group ' + groupName + '.';
    }
    /*
    * @description method that concatinate Body email message with the name of the public group
    * @param name of the public group
    * @return Body email message that concatinated with the name of the public group
    */
    public String concEmailBody(String grpName) {
        return 'Congritulations, you have been added to public group ' + grpName + 
        ' as a group member.\nFor more details, please contact your system administrator.';
    }
}
