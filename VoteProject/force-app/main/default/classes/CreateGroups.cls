public with sharing class CreateGroups{
    public static final List<String> userRoles = new List<String>{
        'Configurator',
        'Moderator',
        'Voter',
        'Analyst'};

    public static List<Group> createUserGroups(List<Campaign__c> campNew){
        List<Group> newGroups = new List<Group>();
        for(Campaign__c camp : campNew){
            for (String role: userRoles) {
                newGroups.add(new Group(Name = 'CMP-' + camp.Campaign_Number__c + '-' + role));
            }
        }
        insert newGroups;
        return newGroups;

    }

    public static void deleteUserGroups(List<Campaign__c> campDel){
        List<String> selectGroups = new List<String>();
        for (Campaign__c c: campDel){
            for (String role: userRoles) {
                selectGroups.add('CMP-' + c.Campaign_Number__c + '-' + role);
            }
        }
        List<Group> delGroups = [SELECT Name FROM Group WHERE Name IN :selectGroups];
        delete delGroups;
    }
}
