class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.create(answer_params)
  end

  def destroy
    answer.destroy.question if current_user.author_of?(answer)
  end

  def update
    if current_user.author_of?(answer.question) && !answer_params[:correct].nil?
      answer.question.answers.each { |answer| answer.update(correct: false) }
      answer.update(answer_params)
      render 'answers/update'
    elsif current_user.author_of?(answer)
      answer.update(answer_params)
      render 'answers/update'
    end
  end

  private

  def answer
    @answer ||= Answer.find(params[:id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :correct).merge(author: current_user)
  end
end
