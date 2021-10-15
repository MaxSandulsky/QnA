import consumer from "./consumer"
import {TemplateHandler} from 'utilities/template_handler'

consumer.subscriptions.create("QuestionsChannel", {
    initialized() {
        this.update
    },

    connected() {
        if (document.querySelector('.questions-list')) {
            this.perform('follow', { question_id: 'questions' } )
            return
        }
        const question = document.querySelector('.question')

        this.perform('follow', { question_id: question.id } )
    },

    received(row_html) {
      {
        let template = new TemplateHandler(row_html)

        if (template.comment()) {
            template.insert_comment()
        } else if (template.answer()) {
            template.insert_answer()
        } else if (template.question()) {
            template.insert_question()
        }
      }
    }
})
