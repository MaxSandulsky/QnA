import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  initialized() {
    this.update
  },

  connected() {
    this.perform('follow')
  },

  received(data) {
    const questions_list = document.querySelector('.questions-list')
    questions_list.insertAdjacentHTML('beforeend', data)
  }
})
