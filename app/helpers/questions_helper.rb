module QuestionsHelper
  def link_to_delete_question(question)
    link_to t('.delete'), question, method: :delete
  end

  def link_to_edit_question(question)
    link_to t('.edit'), question, class: 'button-question-edit'
  end

  def link_to_delete_question_attachment(file)
    link_to t('.delete'), remove_attachment_question_path(attachment_id: file.id), class: "file-delete-#{file.id}",
                                                                                   method: :patch, remote: true
  end

  def link_to_add_reward(question)
    link_to t('.add_reward'), '', class: 'reward-link', remote: true
  end

  def gist_from_link(url)
    GistParseService.new(url).content
  end

  def link_to_upvote_question(question)
    link_to (heroicon 'chevron-up', options: { class: "chevron up #{chevron_params(question, true)}" }),
            upvote_question_path(question), class: 'question-vote', id: question.id,
                                            data: { type: :json }, method: :post, remote: true
  end

  def link_to_downvote_question(question)
    link_to (heroicon 'chevron-down', options: { class: "chevron down #{chevron_params(question, false)}" }),
            downvote_question_path(question), class: 'question-vote', id: question.id,
                                              data: { type: :json }, method: :post, remote: true
  end

  def link_to_new_question_comment(_question)
    link_to t('.new_comment'), new_comment_question_path, class: 'button-comment-question', remote: true
  end

  def link_to_subscribe(question)
    link_to t('.subscribe'), subscribe_question_path(question), class: 'button-subscribe-question', method: :patch, remote: true
  end

  def link_to_unsubscribe(question)
    link_to t('.unsubscribe'), unsubscribe_question_path(question), class: 'button-unsubscribe-question', method: :patch, remote: true
  end

  private

  def chevron_params(question, direction)
    return 'selected' if (current_user&.vote_for(question))&.promote == direction
  end
end
