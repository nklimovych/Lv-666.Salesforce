/*
* Class contains method that configure apex queueable job for create records 
* in Group object, based on list of VoteCampaign__c sObjects from VoteCampaignTrigger
*/
public without sharing class CreatePublicGroups implements Queueable{
    private List<VoteCampaign__c> votecampaignslist;
    private Set<String> votecampaignsroles = new Set<String>{'Configurators', 'Moderators', 'Analysts', 'Voters'};
    /*
    * @description class constructor that collect list of VoteCampaign__c sObjects from VoteCampaignTrigger
    * and assign it to the votecampaignlist variable
    * @param list of VoteCampaign__c sObjects from VoteCampaignTrigger
    */
    public CreatePublicGroups(List<VoteCampaign__c> votecampaigns) {
        this.votecampaignslist = votecampaigns;
    }
    /*
    * @description method that configure apex queueable job for create records 
    * in Group object, based on list of VoteCampaign__c sObjects from VoteCampaignTrigger.
    * Also invoke apex queueble job for create GroupMember object records related to appropriate public groups
    * Commented rows contains code for apex queueble job debugging
    * @param implements QueueableContext interface
    */
    public void execute(QueueableContext context) {
        List<Group> groupstocreate = new List<Group>();
        for (VoteCampaign__c votecampaign : votecampaignslist) {
            for (String role : votecampaignsroles) {
                Group publicgroup = new Group();
                publicgroup.Name = 'CMP-' + votecampaign.Name + '-' + role;
                publicgroup.Type = 'Regular';
                groupstocreate.add(publicgroup);
            }
        }
        insert groupstocreate;
        Map<Id,Group> groupsmap = new Map<Id, Group>(groupstocreate);
        List<Id> groupsids = new List<Id>(groupsmap.keySet());
        List<Group> groupstoaddmembers = [SELECT Id, Name, CreatedById FROM Group WHERE Id IN :groupsids AND Name LIKE '%Configurators'];
        AddMembersToPublicGroups addmembersjob = new AddMembersToPublicGroups(groupstoaddmembers);
        ID addmembersjobid = System.enqueueJob(addmembersjob);
        //AsyncApexJob addmembersjob_log = [SELECT Id, Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :addmembersjobid];
        //System.debug('Add members job log: ' + addmembersjob_log);
    }   
}
