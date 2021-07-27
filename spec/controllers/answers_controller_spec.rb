RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:post_create) { post :create, params: { question_id: question, answer: answer_params } }
    context 'with valid attributes' do
      let(:answer_params) { attributes_for(:answer) }

      it 'saves a new answer in database' do
        expect { post_create }.to change(Answer, :count).by(1)
      end

      it 'redirect to question with new answer' do
        post_create

        expect(response).to redirect_to assigns(:answer).question
      end
    end

    context 'with invalid attributes' do
      let(:answer_params) { attributes_for(:answer, :invalid) }

      it 'didn`t save answer' do
        expect { post_create }.to_not change(Answer, :count)
      end

      it 'render new view' do
        post_create

        expect(response).to render_template :new
      end
    end
  end
end
