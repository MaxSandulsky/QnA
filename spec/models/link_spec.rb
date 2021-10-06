RSpec.describe Link, type: :model do
  it { is_expected.to belong_to :linkable }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :url }

  describe 'transform_if_gist' do
    let(:link) { create(:link) }

    it 'should be correct gist link' do
      link.url = 'https://gist.github.com/MaxSandulsky/659290bad6df910b28d514bed4cfd22a'
      link.transform_if_gist
    end
  end

  describe '#gist?' do
    let(:link) { create(:link) }

    it "should return true if gist" do
      link.url = 'https://gist.github.com/MaxSandulsky/659290bad6df910b28d514bed4cfd22a'

      expect(link.gist?).to be_truthy
    end

    it "should return false" do
      expect(link.gist?).to be_falsey
    end
  end

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
