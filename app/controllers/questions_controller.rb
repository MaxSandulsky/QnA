class QuestionsController < ApplicationController
  include Voted
  include Commented

  after_action :publish_question, only: %i[create]

  skip_authorization_check only: %i[show index]

  load_and_authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answers = question.answers
    new_answer.links.build
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
    question.destroy
    redirect_to questions_path, notice: t('.success')
  end

  def update
    question.update(question_params)
  end

  def remove_attachment
    question.files.find(params[:attachment_id]).purge
    render 'questions/remove_attachment'
  end

  private

  helper_method :question, :new_answer

  def new_answer
    @answer = question.answers.new
  end

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                                    links_attributes: %i[name url id _destroy],
                                                    reward_attributes: %i[name picture id _destroy])
  end

  def publish_question
    return if question.errors.any?

    ActionCable.server.broadcast(
      'questions', ApplicationController.render(
                     partial: 'questions/question',
                     locals: { question: question }
                   )
    )
  end
end
