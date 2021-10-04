RSpec.describe Link, type: :model do
  it { is_expected.to belong_to :linkable }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :url }

  describe "validates format of url" do
    let(:link) { create(:link) }

    it "shouldn't be valid with bad url" do
      link.url = 'test'

      expect(link).to_not be_valid
    end

    it "should be valid with proper url" do
      expect(link).to be_valid
    end
  end
end
