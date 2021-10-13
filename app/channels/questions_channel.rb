class QuestionsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from data['question_id'] if data['question_id']
  end
end
