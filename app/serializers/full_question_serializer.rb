class FullQuestionSerializer < ActiveModel::Serializer
  attributes :id, :body, :title, :created_at, :updated_at, :author_id, :short_links, :files_urls, :short_comments

  has_many :answers
  
  def short_links
    object.links.map { |link| { url: link.url, name: link.name } }
  end

  def files_urls
    object.files.map { |file| { url: file.url } }
  end

  def short_comments
    object.comments.map { |comment| comment.attributes.except('commentable_id', 'commentable_type') }
  end
end
