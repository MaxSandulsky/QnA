import { enable_answersInQuestion } from 'utilities/form_inline'

document.addEventListener('turbolinks:load', () => {
  enable_answersInQuestion('.form-answer', '.answer-button')
})
