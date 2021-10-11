require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { is_expected.to belong_to :commentable }
  it { is_expected.to belong_to :author }

  it { is_expected.to validate_presence_of :author }
  it { is_expected.to validate_presence_of :commentable }
  it { is_expected.to validate_presence_of :text }
end
