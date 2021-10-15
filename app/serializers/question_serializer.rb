class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :body, :title, :created_at, :updated_at, :author_id, :short_title
  has_many :answers

  def short_title
    object.title.truncate(7)
  end
end
