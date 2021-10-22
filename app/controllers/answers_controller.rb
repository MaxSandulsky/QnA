class AnswersController < ApplicationController
  include Voted
  include Commented

  after_action :publish_answer, only: %i[create]

  load_and_authorize_resource

  def create
    @answer = question.answers.create(create_params)
  end

  def destroy
    answer.destroy
  end

  def update
    render 'answers/update' if answer.update(answer_params)
  end

  def mark
    render 'answers/mark' if answer.mark_as(answer_params[:correct])
  end

  def remove_attachment
    answer.files.find(params[:attachment_id]).purge
    render 'answers/remove_attachment'
  end

  private

  helper_method :question, :new_answer

  def new_answer
    @answer = question.answers.new
  end

  def answer
    @answer ||= Answer.find(params[:id]) if params[:id]
    @answer
  end

  def question
    @question ||= answer.question if answer
    @question ||= Question.find(params[:question_id])
    @question
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
