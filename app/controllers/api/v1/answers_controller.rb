class Api::V1::AnswersController < Api::V1::BaseController
  load_and_authorize_resource

  def show
    render json: answer, serializer: FullAnswerSerializer
  end

  def answer
    @answer = Answer.load_with_attachments.find(params[:id])
  end
end
