module Voted
  extend ActiveSupport::Concern

  def upvote
    responding(true)
  end

  def downvote
    responding(false)
  end

  def responding(value)
    @voted = self.send(controller_name.singularize.to_sym)
    @vote = @voted.votes.build(promote: value, user: current_user)

    respond_to do |format|
      if @vote.save
        @vote.purge_votes

        format.json { render json: { votes_sum: @voted.votes_sum, obj_id: @voted.id, } }
      else
        @vote.purge_votes

        format.json { render json: { votes_sum: @voted.votes_sum, obj_id: @voted.id, errors: @vote.errors.full_messages } }
      end
    end
  end
end
