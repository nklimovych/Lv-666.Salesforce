import { LightningElement,track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAssignedQuestionToCampaign from '@salesforce/apex/LwcControllers.getAssignedQuestionToCampaign';
import saveVoteResults from '@salesforce/apex/VoteResultsController.saveVoteResults';

export default class votingComponent extends LightningElement {
    //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
    @track isModalOpen = false;
    @track questions = [];
    @api recordId;
    @track answers = [];
    savedAnswers = {};

    @wire(getAssignedQuestionToCampaign, {campaignId: '$recordId'})
    wiredQuestions ({ data, error }){
        if(data){
            this.questions = data;
            this.error = error;
        }
    }
    
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
       
    }
    submitDetails(event) {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
        saveVoteResults({answerData: this.savedAnswers})
        .then((result) => {
            this.voteResults = result;
            this.saveResultsError = undefined;
            this.showToast(
                'Congritulations! Your vote(s) has been counted!',
                undefined,
                'success'
            );
        })
        .catch((error) => {
            this.saveResultsError = error;
            this.voteResults = undefined;
            this.showToast(
                'Oops, we have some troubles with saving your vote results =(',
                undefined,
                'error'
            );
        });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }

    saveVotes(event){
        console.log('saveVotes');
        let voteId = event.detail.target.dataset.votingId;
        console.log(voteId);
        let answerId = event.detail.target.dataset.answerId;
        console.log(answerId);
        console.log(this.recordId);
        this.savedAnswers[voteId] = {
            'votingId': voteId,
            'answerId': answerId,
            'campaignId': this.recordId,
        }
        console.log(this.savedAnswers);

    }


}