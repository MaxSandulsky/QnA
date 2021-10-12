class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!

  after_action :publish_answer, only: %i[create]

  def create
    @answer = question.answers.create(create_params)
  end

  def destroy
    answer.destroy.question if current_user.author_of?(answer)
  end

  def update
    render 'answers/update' if current_user.author_of?(answer) && answer.update(answer_params)
  end

  def mark
    render 'answers/mark' if current_user.author_of?(answer.question) && answer.mark_as(answer_params[:correct])
  end

  def remove_attachment
    answer.files.find(params[:attachment_id]).purge if current_user.author_of?(answer)
    render 'answers/remove_attachment'
  end

  private

  def answer
    @answer ||= Answer.find(params[:id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def create_params
    answer_params.merge(author: current_user)
  end

  def answer_params
    params.require(:answer).permit(:body, :correct, files: [], links_attributes: %i[name url id _destroy])
  end

  def publish_answer
    return if answer.errors.any?
    ActionCable.server.broadcast(
      "question-#{question.id}", AnswersController.render_with_signed_in_user(
          current_user,
          partial: 'answers/answer',
          locals: { answer: answer, current_user: current_user }
      )
    )
  end
end
