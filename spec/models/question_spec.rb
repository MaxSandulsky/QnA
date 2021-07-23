RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_uniqueness_of(:title).case_insensitive }
  
  it { should have_many(:answers).dependent(:destroy) }
end
