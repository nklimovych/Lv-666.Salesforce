/*
* Class contains method that configure apex queueable job for create GroupMember object
* records related to public groups defined in list of Group sObjects
*/
public without sharing class AddMembersToPublicGroups implements Queueable {
    private List<Group> publicgroups;
    /*
    * @description class constructor that collect list of appropriate Group sObjects from CreatePublicGroups class
    * and assign it to the publicgroups variable
    * @param list of Group sObjects from CreatePublicGroups class
    */
    public AddMembersToPublicGroups(List<Group> publicgroups) {
        this.publicgroups = publicgroups;
    }
    /*
    * @description method that configure apex queueable job for create GroupMember object
    * records related to public groups, based on list of Group sObjects from CreatePublicGroups class, 
    * and catch the appropriate exception if inserting records was unsuccessful with displaying an appropriate debug message
    * with description about an error.
    * Also invoke sendMail method from EmailManager class that sends email notifications
    * to the users who added to the appropriate public groups as group members.
    * @param implements QueueableContext interface
    */
    public void execute(QueueableContext context) {
        try {
            List<GroupMember> groupmembers = new List<GroupMember>();
                for (Group publicgroup : publicgroups) {
                GroupMember gm = new GroupMember();
                gm.GroupId = publicgroup.Id;
                gm.UserOrGroupId = UserInfo.getUserId();
                groupmembers.add(gm);
                String useremail = UserInfo.getUserEmail();
                EmailManager.sendMail(useremail, 'You have been added to public group ' + publicgroup.Name + 
                '.', 'Congritulations, you have been added to public group ' + publicgroup.Name + 
                ' as a group member.' + '\nFor more details, please contact your system administrator.');
                }
            insert groupmembers;

        } catch (DmlException e) {
            System.debug('An error has occurred while adding members to the public groups: ' + e.getMessage());
        }
    }
}
