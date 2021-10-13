module Commented
  extend ActiveSupport::Concern

  included do
    after_action :publish_comment, only: :create_comment
  end

  def new_comment
    @commented = send(controller_name.singularize.to_sym)
    @comment = @commented.comments.new
  end

  def create_comment
    @comment = send(controller_name.singularize.to_sym).comments.build(comment_params)
    @comment.save!
  end

  private

  def comment_params
    params.require(controller_name.singularize.to_sym).permit(comment: [:text])[:comment].merge(author: current_user)
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      "question-#{commentable_id}", ApplicationController.render(
                                      partial: 'comments/comment',
                                      locals: { comment: @comment }
                                    )
    )
  end

  def commentable_id
    if defined?(@comment.commentable.question.id)
      @comment.commentable.question.id
    else
      @comment.commentable_id
    end
  end
end
