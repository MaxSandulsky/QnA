module QuestionsHelper
  def link_to_delete_question(question)
    link_to t('.delete'), question, method: :delete if current_user&.author_of?(question)
  end

  def link_to_edit_question(question)
    link_to t('.edit'), question, class: 'button-question-edit' if current_user&.author_of?(question)
  end

  def link_to_delete_question_attachment(file)
    link_to t('.delete'), remove_attachment_question_path(attachment_id: file.id), class: "file-delete-#{file.id}", method: :patch, remote: true
  end
end
