class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!

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
end
