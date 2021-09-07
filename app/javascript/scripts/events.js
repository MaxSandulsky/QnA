import {answer_InlineForm, answer_InlineForm_with_target} from "./answers";
import {question_InlineForm_with_target} from "./questions"
import {disable_default_behavior} from "./common"

document.addEventListener('turbolinks:load', () => {
  answer_InlineForm('.form-answer-new', '.button-answer-new')
  answer_InlineForm_with_target('.form-answer-edit', '.answers', '.button-answer-edit')
  question_InlineForm_with_target('.form-question-edit', '.question', '.button-question-edit')
  disable_default_behavior('.button-answer-delete')
  disable_default_behavior('.answer-mark')
})
