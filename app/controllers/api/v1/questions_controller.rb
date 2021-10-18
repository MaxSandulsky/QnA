class Api::V1::QuestionsController < Api::V1::BaseController
  load_and_authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: question, serializer: FullQuestionSerializer
  end

  private

  def question
    @question = Question.load_with_attachments.find(params[:id])
  end
end
