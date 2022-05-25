import { LightningElement, api , wire, track } from 'lwc';
import getAssignedAnswersToQuestions from '@salesforce/apex/LwcControllers.getAssignedAnswersToQuestions';

export default class QuizAnswers extends LightningElement {
    nodata;
    votingId;
    @track answers;

    @wire(getAssignedAnswersToQuestions, ({questionId: '$votingId'}))
    getAnswersToQuestion({error, data}){
        if(data){
            this.answers = data;
            console.log(data);
            console.log(this.answers);
        }
    }

    @api
    get question() {
        return this.votingId;
    }
    set question(value) {
        this.votingId = value;
        console.log('setter');
        console.log(this.votingId);
    }

    handleClick(event) {
        console.log('handleClick event');
        console.log(this.votingId);
        const answerEvent = new CustomEvent('answer', { detail: event});
        this.dispatchEvent(answerEvent);
    }
}

