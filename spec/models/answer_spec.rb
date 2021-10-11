RSpec.describe Answer, type: :model do
  it { is_expected.to validate_presence_of :body }
  it { is_expected.to validate_presence_of :question }
  
  it { is_expected.to belong_to(:author) }
  it { is_expected.to belong_to(:question) }

  it { is_expected.to have_many(:links).dependent(:destroy) }
  it { is_expected.to have_many(:votes).dependent(:destroy) }

  it { is_expected.to accept_nested_attributes_for :links }

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

  describe '#mark_as' do
    let(:question) { create(:question_with_answers) }

    before do
      question.answers.first.mark_as(true)
    end

    it 'should mark answer as correct' do
      expect(question.answers.first.correct).to be_truthy
    end

    it 'should mark another answer as correct' do
      question.answers.last.mark_as(true)

      expect(question.answers.select(&:correct).count).to eq(1)
    end

    it 'should mark answer as false' do
      question.answers.last.mark_as(false)

      expect(question.answers.select(&:correct).count).to eq(0)
    end
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
