module QuestionsHelper
  def link_to_delete(subject)
    link_to 'Удалить', subject, method: :delete if current_user&.author_of?(subject)
  end
end