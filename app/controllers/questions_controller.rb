class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    @answers = question.answers
  end

  def new; end

  def create
    @question = current_user.questions.build(question_params)

    if question.save
      redirect_to question, notice: t('.success')
    else
      render :new
    end
  end

  def destroy
    if question.author == current_user
      question.destroy
      redirect_to questions_path, notice: t('.success')
    else
      redirect_to question, notice: t('.ownership_violation')
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
