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
        SendEmails sendemailsjob = new SendEmails(address, subject, body);
        ID sendemailsjobid = System.enqueueJob(sendemailsjob);
        // AsyncApexJob sendemailsjob_log = [SELECT Id, Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :sendemailsjobid];
        // System.debug('Add members job log: ' + sendemailsjob_log);
    }

}
