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
    public SendEmails(String address, String subject, String body) {
        this.address = address;
        this.subject = subject;
        this.body = body;
    }
    /*
    * @description method that configure apex queueable job to send email notifications
    * to the users who added to the appropriate public groups as group members 
    * and catch the appropriate error if sending email notification message was unsuccessful with displaying an appropriate debug message
    * with description about an error.
    * @param implements QueueableContext interface
    */
    public void execute (QueueableContext context) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {address};
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(
                                 new Messaging.SingleEmailMessage[] { mail });
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                System.debug('Email sent successfully');
            }
            else {
                System.debug('The following errors occurred: ' + res.getErrors());                 
            }
        }
    }
}
