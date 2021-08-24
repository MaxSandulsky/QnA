class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def create
    @answer = question.answers.build(answer_params)
    if @answer.save
      redirect_to question, notice: t('.success')
    else
      render 'questions/show', locals: { question: question }
    end
  end

  def destroy
    if current_user.author_of?(answer)
      redirect_to answer.destroy.question, notice: t('.success')
    else
      redirect_to answer.question, notice: t('.ownership_violation')
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
    params.require(:answer).permit(:body).merge(author: current_user)
  end
end
