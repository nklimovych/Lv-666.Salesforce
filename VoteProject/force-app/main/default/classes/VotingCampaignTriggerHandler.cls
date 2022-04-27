/**
 * An Apex class to handle complexity in trigger logic set.  It is used
 * to provide a better way of writing complex logic that's required for
 * trigger code and also avoid creating more than one trigger per object
 */
public with sharing class VotingCampaignTriggerHandler extends CustomMDTTriggerHandler{

    CreateGroups newGroups = new CreateGroups();
    public List<Campaign__c> newCampaings = new List<Campaign__c>();
    public List<Campaign__c> oldCampaings = new List<Campaign__c>();

    /**
     * Parameterized constructor that takes two list arguments of 
     * campaign object
     * @param  newCampaings The list of new Campaign objects
     * @param  oldCampaings The list of old Campaign objects
     */
    public votingCampaignTriggerHandler(List<Campaign__c> newCampaings, List<Campaign__c> oldCampaings) {
        this.newCampaings = newCampaings;
        this.oldCampaings = oldCampaings;
    }

    /**
     * Default constructor
     */
    public votingCampaignTriggerHandler(){
        this((List<Campaign__c>)Trigger.new, (List<Campaign__c>)Trigger.old);
    }

    /**
     * After campaign object or list of objects is inserted this 
     * method is invoked to add user to public group 'Configurator'
     */
    public override void afterInsert(){
        System.enqueueJob(new AddUserToGroup(newGroups.createUserGroups(newCampaings)));
    }

    /**
     * After campaign object or list of objects is deleted this 
     * method invokes to delete public groups assigned to that 
     * campaign object
     */
    public override void afterDelete(){
        newGroups.deleteUserGroups(oldCampaings);
    }
}
