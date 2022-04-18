public with sharing class CampaignManager{
    /**
     * @description creates public groups for any campaign inserted
     * @param  addedCampaigns list of inserted campaigns
     */ 
    public static void createGroups(List<Voting_Campaign__c> addedCampaigns){
        String[] types = new String[]{'-CONFG', '-VOTER', '-MODER', '-ANLTC'};
        List<Group> groups = new List<Group>();
        for(Voting_Campaign__c vc: addedCampaigns){
            for(String s: types){
                groups.add(new Group(Name='CMP-'+vc.Voting_Campaign_Number__c+s));
            }
        }
        insert groups;

        //Adding group creator as a configurator using Queueable class 
        GroupMemberUtility_Queueable addConfigurator = new GroupMemberUtility_Queueable(groups);
        System.enqueueJob(addConfigurator);
    }

    /**
     * @description deletes public groups for any campaign deleted
     * @param  deletedCampaigns list of deleted campaigns
     */ 
    public static void deleteGroups(List<Voting_Campaign__c> deletedCampaigns){
        String[] filters = new String[]{};
        for(Voting_Campaign__c vc: deletedCampaigns){
            filters.add('%' + vc.Voting_Campaign_Number__c + '%');
        }
        List<Group> groupsToDelete = [SELECT ID, OwnerId, Name FROM Group WHERE Name LIKE :filters];
        delete groupsToDelete;
    }  
}