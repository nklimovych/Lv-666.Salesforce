public with sharing class GroupMemberUtils implements Queueable{
    
    public Set<Id> configuratorGroupsId = new Set<Id>();

    // Method adds user who created campaign to configurator public group
    public GroupMemberUtils(Set<Id> groupsIdList){
        this.configuratorGroupsId = groupsIdList;
    }

    public void execute(QueueableContext context){
        List<GroupMember> usersToBeInserted = new List<GroupMember>();
        for(Id groupId: configuratorGroupsId){
            usersToBeInserted.add(new GroupMember(
                GroupId = groupId,
                UserOrGroupId = UserInfo.getUserId()
                )
            );
        }
        
        try{
            insert usersToBeInserted;
        }catch(DmlException e){
            Id s = System.enqueueJob(new MailNotification(e));
        }
    }

    // Class for asynchronous mail notifications
    public class MailNotification implements Queueable{
    
    DmlException exceptionReason = new DmlException();
    public MailNotification(DmlException e){
        this.exceptionReason = e;
    }

    public void execute(QueueableContext context){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[]  {UserInfo.getUserEmail()});
            mail.setSubject(
                'Apex DML_EXCEPTION!'
            );
            mail.setSenderDisplayName('Salesforce admin');
            String content = 'You got some issue in GroupMemberUtils class when inserting user to public group. </br></br> Problem message: ' + exceptionReason.getMessage(); 
            mail.setHtmlBody(content);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}