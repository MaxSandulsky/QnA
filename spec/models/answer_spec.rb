RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question }
  it { should validate_presence_of :author }

  it { should belong_to(:author) }
  it { should belong_to(:question) }
end
