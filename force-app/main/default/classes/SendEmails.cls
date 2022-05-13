/*
* Class contains method that configure apex queueable job to send email notifications
* to the users who added to the appropriate public groups as group members
*/
public without sharing class SendEmails implements Queueable {
    private String address;
    private String subject;
    private String body;
    /*
    * @description class constructor that collect required information about email notification message
    * and assign it to the appropriate variables 
    * @param(address) contains email address for the email notification message
    * @param(subject) contains subject of the email notification message
    * @param(body) contains body of the email notification message 
    */
    public SendEmails(String newAddress, String newSubject, String newBody) {
        this.address = newAddress;
        this.subject = newSubject;
        this.body = newBody;
    }
    /*
    * @description method that configure apex queueable job to send email notifications
    * to the users who added to the appropriate public groups as group members 
    * @param implements QueueableContext interface
    */
    public void execute (QueueableContext context) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {address};
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        Messaging.sendEmail(
        new Messaging.SingleEmailMessage[] { mail });
    }
}
