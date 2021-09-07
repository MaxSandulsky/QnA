RSpec.describe Answer, type: :model do
  it { is_expected.to validate_presence_of :body }
  it { is_expected.to validate_presence_of :question }
  it { is_expected.to belong_to(:author) }
  it { is_expected.to belong_to(:question) }

  describe 'validates that it`s the only one correct answer' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let(:correct_answer) { create(:answer, question: question, correct: true) }

    it 'should be valid if no correct answers present yet' do
      answer.correct = true
      answer.validate

      expect(answer.errors[:correct]).to_not include('Лучший ответ может быть только один')
    end

    it 'shouldn`t` be valid if correct answer present' do
      correct_answer
      answer.correct = true
      answer.validate

      expect(answer.errors[:correct]).to include('Лучший ответ может быть только один')
    end
  end
end
