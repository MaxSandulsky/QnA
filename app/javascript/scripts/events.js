import {answer_InlineForm, answer_InlineForm_with_target} from "./answers";
import {question_InlineForm_with_target} from "./questions"
import {disable_default_behavior, votes_by_ajaj_with_target} from "./common"

document.addEventListener('turbolinks:load', () => {
    votes_by_ajaj_with_target('.answers', '.vote-sum', '.answer-vote', '.answer-')
    answer_InlineForm('.form-answer-new', '.button-answer-new')
    answer_InlineForm_with_target('.form-answer-', '.answers', '.edit-')
    question_InlineForm_with_target('.form-question-edit', '.question', '.button-question-edit')
    disable_default_behavior('.button-answer-delete')
})
