module AnswersHelper
  def link_to_delete_answer(answer)
    link_to 'Удалить', answer, class: "button-answer-delete #{answer.id} tab", method: :delete, remote: true if current_user&.author_of?(answer)
  end

  def link_to_edit_answer(answer)
    link_to t('.edit'), answer, class: "button-answer-edit #{answer.id} tab", data: { answer_id: answer.id } if current_user&.author_of?(answer)
  end

  def link_to_false_mark(answer)
    link_to (heroicon "check", options: { class: "answer-mark correct" }), answer_path(answer, answer: { correct: false }), method: :patch, remote: true
  end

  def link_to_true_mark(answer)
    link_to (heroicon "check", options: { class: "answer-mark" }), answer_path(answer, answer: { correct: true }), method: :patch, remote: true
  end
end
