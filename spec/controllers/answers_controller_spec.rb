RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'POST #create' do
    let(:post_create) { post :create, params: { question_id: question, answer: answer_params } }

    context 'with valid attributes' do
      let(:answer_params) { attributes_for(:answer) }

      it 'saves a new answer in database' do
        expect { post_create }.to change(question.answers, :count).by(1)
      end

      it 'redirect to question with new answer' do
        post_create

        expect(response).to redirect_to assigns(:answer).question
      end
    end

    context 'with invalid attributes' do
      render_views

      let(:answer_params) { attributes_for(:answer, :invalid) }

      it 'render new view' do
        post_create

        expect(response).to render_template(partial: 'answers/_new')
      end

      it 'didn`t save answer' do
        expect { post_create }.not_to change(question.answers, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'delete users answer' do
      let!(:own_answer) { create(:answer, author: user) }
      let(:delete_destroy) { delete :destroy, params: { id: own_answer } }

      it 'destroy answer' do
        expect { delete_destroy }.to change(Answer, :count).by(-1)
      end
    end

    context 'delete unfamiliar answer' do
      let!(:answer) { create(:answer) }
      let(:delete_destroy) { delete :destroy, params: { id: answer } }

      it "don't destroy answer" do
        expect { delete_destroy }.to change(Answer, :count).by(0)
      end
    end

    it 'redirect to question' do
      delete :destroy, params: { id: answer }

      expect(response).to redirect_to answer.question
    end
  end
end
