public with sharing class LwcControllers {
    @AuraEnabled
    public static List<User> getUsers(ID cmpId, Integer lim, String userType) {
        Voting_Campaign__c vc = [SELECT ID, NumberOfCampaign__c FROM Voting_Campaign__c WHERE ID = :cmpId LIMIT 1];
        String filter = '%' + vc.NumberOfCampaign__c + '-' + userType;
        Set<ID> groupsId = (new Map<ID, SObject>([SELECT Id FROM Group WHERE Name LIKE :filter]).keySet());
        System.debug('filter' + filter);
        System.debug('groupsId : ' + groupsId);
        System.debug('vs: ' + vc);
        return  [SELECT Id, Name, Username FROM User WHERE ID IN (SELECT UserOrGroupId FROM GroupMember WHERE GroupId IN :groupsId ) LIMIT :lim];
    }

    @AuraEnabled(cacheable=true)
    public static List<Voting_Question__c> getAssignedQuestionToCampaign(Id campaignId) {
        List<Voting_Campagin_Question__c> campaignQuestionObjectsList= [SELECT Voting_Question__c FROM Voting_Campagin_Question__c WHERE Question_for_campaign__c =:campaignId];
        
        List<Id> idsOfAssignedQuestionsToCampaign = new List<Id>();
        for(Voting_Campagin_Question__c currCampaignQuestion: campaignQuestionObjectsList) {
            idsOfAssignedQuestionsToCampaign.add(
                currCampaignQuestion.Voting_Question__c
            );
        }

        return [SELECT Name FROM Voting_Question__c WHERE Id IN :idsOfAssignedQuestionsToCampaign];
    }
    
    @AuraEnabled(cacheable=true) 
    public static List<Voting_Answer__c> getAssignedAnswersToQuestions(Id questionId) {
        List<Voting_Question_Answer__c> listOfQuestinAnswers = [SELECT Voting_Answer__c FROM Voting_Question_Answer__c WHERE Voting_Question__c =:questionId];
        List<Id> assignedAnswerIds = new List<Id>();
        for(Voting_Question_Answer__c currQuestionAnswer: listOfQuestinAnswers) {
            assignedAnswerIds.add(currQuestionAnswer.Voting_Answer__c);
        }

        System.debug([SELECT Name FROM Voting_Answer__c WHERE ID IN: assignedAnswerIds]);
        return [SELECT Name FROM Voting_Answer__c WHERE ID IN: assignedAnswerIds];
    }
}

