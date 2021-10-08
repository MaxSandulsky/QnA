module QuestionsHelper
  def link_to_delete_question(question)
    link_to t('.delete'), question, method: :delete if current_user&.author_of?(question)
  end

  def link_to_edit_question(question)
    link_to t('.edit'), question, class: 'button-question-edit' if current_user&.author_of?(question)
  end

  def link_to_delete_question_attachment(file)
    link_to t('.delete'), remove_attachment_question_path(attachment_id: file.id), class: "file-delete-#{file.id}",
                                                                                   method: :patch, remote: true
  end

  def link_to_add_reward
    link_to t('.add_reward'), '', class: 'reward-link', remote: true
  end

  def gist_from_link(url)
    GistParseService.new(url).content
  end

  def link_to_upvote_question(question)
    link_to (heroicon 'chevron-up', options: { class: 'chevron up' }),
             upvote_question_path(question), class: "question-upvote",
             method: :post, remote: true
  end

  def link_to_downvote_question(question)
    link_to (heroicon 'chevron-down', options: { class: 'chevron down' }),
             downvote_question_path(question), class: "question-downvote",
             method: :post, remote: true
  end
end
