class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :correct, :updated_at, :author_id
end
