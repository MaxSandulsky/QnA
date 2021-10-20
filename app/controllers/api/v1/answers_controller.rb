class Api::V1::AnswersController < Api::V1::BaseController
  load_and_authorize_resource

  protect_from_forgery with: :null_session, only: :create

  def index
    render json: question.answers, root: 'answers'
  end

  def show
    render json: answer, serializer: FullAnswerSerializer
  end

  def answer
    @answer = Answer.load_with_attachments.find(params[:id])
  end

  def create
    @answer = question.answers.build(create_params)
    if @answer.save
      render json: @answer, serializer: FullAnswerSerializer
    else
      render json: @answer.errors.full_messages
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer, serializer: FullAnswerSerializer
    else
      render json: @answer.errors.full_messages
    end
  end

  private

  def create_params
    answer_params.merge(author: current_user)
  end

  def answer_params
    params.require(:answer).permit(:body, :correct, links_attributes: %i[name url id _destroy])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end
end
