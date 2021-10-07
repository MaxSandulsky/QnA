class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    @answers = question.answers
    @answer = question.answers.new
    @answer.links.build
  end

  def new
    question.links.build
    question.reward = Reward.new
  end

  def create
    @question = current_user.questions.build(question_params)

    if question.save
      redirect_to question, notice: t('.success')
    else
      render :new
    end
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: t('.success')
    else
      redirect_to question, notice: t('.ownership_violation')
    end
  end

  def update
    question.update(question_params)
  end

  def remove_attachment
    question.files.find(params[:attachment_id]).purge if current_user.author_of?(question)
    render 'questions/remove_attachment'
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                                    links_attributes: %i[name url id _destroy],
                                                    reward_attributes: %i[name picture id _destroy])
  end
end
