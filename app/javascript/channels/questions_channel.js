import consumer from "./consumer"

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

    received(data) {
        if (data.includes('comment')) {
            const comments = document.querySelector('.comments')
            comments.insertAdjacentHTML('beforeend', data)
        }
        else if (data.includes('question')) {
            const questions_list = document.querySelector('.questions-list')
            questions_list.insertAdjacentHTML('beforeend', data)
        }
    }
})
