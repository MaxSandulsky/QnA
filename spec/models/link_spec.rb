RSpec.describe Link, type: :model do
  it { is_expected.to belong_to :linkable }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :url }

  describe '#gist?' do
    let(:link) { create(:link) }

    it 'returns true if gist' do
      link.url = 'https://gist.github.com/MaxSandulsky/659290bad6df910b28d514bed4cfd22a'

      expect(link.gist?).to be_truthy
    end

    it 'returns false' do
      expect(link.gist?).to be_falsey
    end
  end

  describe 'validates format of url' do
    let(:link) { create(:link) }

    it 'is not valid with bad url' do
      link.url = 'test'

      expect(link).not_to be_valid
    end

    it 'is valid with proper url' do
      expect(link).to be_valid
    end
  end
end
