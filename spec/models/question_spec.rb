RSpec.describe Question, type: :model do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to belong_to(:author) }

  describe 'should have only one or less correct answers' do
    let!(:question) { create(:question_with_answers) }

    it 'answer_correct should return one answer' do
      question.answers.each { |answer| answer.update(correct: true) }
    end
  end

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
