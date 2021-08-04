RSpec.describe Answer, type: :model do
  it { is_expected.to validate_presence_of :body }
  it { is_expected.to validate_presence_of :question }
  it { is_expected.to validate_presence_of :author }

  it { is_expected.to belong_to(:author) }
  it { is_expected.to belong_to(:question) }
end
