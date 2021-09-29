module AnswersHelper
  def link_to_delete_answer(answer)
    if current_user&.author_of?(answer)
      link_to 'Удалить', answer, class: "button-answer-delete #{answer.id} tab", method: :delete,
                                 remote: true
    end
  end

  def link_to_edit_answer(answer)
    if current_user&.author_of?(answer)
      link_to t('.edit'), answer, class: "button-answer-#{answer.id} edit-#{answer.id} tab",
                                  data: { answer_id: answer.id }
    end
  end

  def link_to_false_mark(answer)
    link_to (heroicon 'check', options: { class: 'check correct' }),
            mark_answer_path(answer, answer: { correct: false }), class: 'answer-mark', method: :patch, remote: true
  end

  def link_to_true_mark(answer)
    link_to (heroicon 'check', options: { class: 'check' }), mark_answer_path(answer, answer: { correct: true }),
            class: 'answer-mark', method: :patch, remote: true
  end
end
