class Api::V1::QuestionsController < Api::V1::BaseController
  load_and_authorize_resource

  protect_from_forgery with: :null_session, only: :create

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: question, serializer: FullQuestionSerializer
  end

  def answers
    render json: question.answers, root: 'answers'
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      render json: @question, serializer: FullQuestionSerializer
    else
      render json: @question.errors.full_messages
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: %i[name url id _destroy],
                                                    reward_attributes: %i[name picture id _destroy])
  end

  def question
    @question = Question.load_with_attachments.find(params[:id])
  end
end
