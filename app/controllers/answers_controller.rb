class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.create(answer_params)
  end

  def destroy
    answer.destroy.question if current_user.author_of?(answer)
  end

  def update
    render 'answers/update' if current_user.author_of?(answer) && answer.update(upd_answ_params)
  end

  def mark
    render 'answers/mark' if current_user.author_of?(answer.question) && answer.mark_as(upd_answ_params[:correct])
  end

  private

  def answer
    @answer ||= Answer.find(params[:id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def upd_answ_params
    params.require(:answer).permit(:body, :correct)
  end

  def answer_params
    params.require(:answer).permit(:body, :correct).merge(author: current_user)
  end
end
