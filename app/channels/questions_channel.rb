class QuestionsChannel < ApplicationCable::Channel
  def follow(data)
    if data['question_id']
      stream_from "question-#{data['question_id']}"
    else
      stream_from "questions"
    end
  end
end
