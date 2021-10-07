require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { is_expected.to belong_to :question }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :picture }

  it 'have one attached files' do
    expect(Reward.new.picture).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  describe "validates format of picture" do
    let(:reward) { create(:reward) }

    it "should be valid with .jpg" do
      reward.picture.attach(io: File.open("#{Rails.root}/spec/support/test_image.jpg"), filename: 'test_image.jpg')

      expect(reward).to be_valid
    end

    it "shouldn't be valid with not jpg" do
      reward.picture.attach(io: File.open("#{Rails.root}/spec/support/controller_helpers.rb"), filename: 'controller_helpers.rb')

      expect(reward).to_not be_valid
    end
  end
end
