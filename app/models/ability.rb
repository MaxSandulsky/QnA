# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, [Question, Answer, Comment]
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :me, User, id: user.id

    can :read, Reward

    can :answers, Question

    can :create, [Question, Answer, Comment, Reward]
    can :update, [Question, Answer], author_id: user.id
    can :destroy, [Question, Answer], author_id: user.id

    can :upvote, [Question, Answer] do |upvotable|
      user.author_of?(upvotable)
    end
    can :downvote, [Question, Answer] do |upvotable|
      user.author_of?(upvotable)
    end

    can :remove_attachment, [Question, Answer], author_id: user.id

    can :mark, Answer, question: { author_id: user.id }

    can :new_comment, [Question, Answer]
    can :create_comment, [Question, Answer]
  end
end
