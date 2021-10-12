import consumer from "./consumer"
import {TemplateHandler} from 'utilities/template_handler'

consumer.subscriptions.create("QuestionsChannel", {
    initialized() {
        this.update
    },

    connected() {
        const question = document.querySelector('.question')
        let question_id

        if (question) {
            question_id = question.dataset.questionId
        }

        this.perform('follow', { question_id: question_id } )
    },

    received(row_html) {
        let template = new TemplateHandler(row_html)
        console.log(row_html);
        if (template.comment()) {
            template.insert_comment()
        } else if (template.answer()) {
            template.insert_answer()
        } else if (template.question()) {
            template.insert_question()
        }
    }
})
