/*
* Class contains method that configure apex queueable job for create records 
* in Group object, based on list of VoteCampaign__c sObjects from VoteCampaignTrigger
*/
public without sharing class CreatePublicGroups implements Queueable{
    private List<VoteCampaign__c> voteCampaignsList;
    private final Set<String> voteCampaignsRoles = new Set<String>{'Configurators', 'Moderators', 'Analysts', 'Voters'};
    /*
    * @description class constructor that collect list of VoteCampaign__c sObjects from VoteCampaignTrigger
    * and assign it to the votecampaignlist variable
    * @param list of VoteCampaign__c sObjects from VoteCampaignTrigger
    */
    public CreatePublicGroups(List<VoteCampaign__c> voteCampaigns) {
        this.voteCampaignsList = voteCampaigns;
    }
    /*
    * @description method that configure apex queueable job for create records 
    * in Group object, based on list of VoteCampaign__c sObjects from VoteCampaignTrigger.
    * Also invoke apex queueble job for create GroupMember object records related to appropriate public groups
    * @param implements QueueableContext interface
    */
    public void execute(QueueableContext context) {
        List<Group> groupsToCreate = new List<Group>();
        for (VoteCampaign__c voteCampaign : voteCampaignsList) {
            for (String role : voteCampaignsRoles) {
                Group publicGroup = new Group();
                publicGroup.Name = 'CMP-' + voteCampaign.Name + '-' + role;
                publicGroup.Type = 'Regular';
                groupsToCreate.add(publicGroup);
            }
        }
        insert groupsToCreate;
        Map<Id,Group> groupsMap = new Map<Id, Group>(groupsToCreate);
        System.enqueueJob(new ManagePublicGroupsMembers([
                                                         SELECT Id, Name, CreatedById 
                                                         FROM Group 
                                                         WHERE Id IN :groupsMap.keySet() 
                                                         AND Name LIKE '%Configurators'
            ])
        );
    }   
}
