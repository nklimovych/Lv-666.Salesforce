/*
* Class contains method that invoke apex queueble job to send email notifications
* to the users who added to the appropriate public groups as group members
*/
public without sharing class EmailManager {
    /*
    * @description method that invoke apex queueble job to send email notifications
    * to the users who added to the appropriate public groups as group members
    * @param(address) contains email address for the email notification message
    * @param(subject) contains subject of the email notification message
    * @param(body) contains body of the email notification message 
    * Commented rows contains code for apex queueble job debugging
    */
    public static void sendMail (String address, String subject, String body) {
        SendEmails sendEmailsJob = new SendEmails(address, subject, body);
        ID sendEmailsJobId = System.enqueueJob(sendEmailsJob);
        // AsyncApexJob sendEmailsJob_Log = [SELECT Id, Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :sendEmailsJobId];
        // System.debug('Add members job log: ' + sendEmailsJob_Log);
    }

}
