RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  before { login(user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question_with_answers, answers_count: 3) }

    before { get :show, params: { id: question } }

    it 'populates all answers related to question' do
      expect(assigns(:answers)).to match_array(question.answers)
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:post_create) { post :create, params: { question: question_params } }

    context 'with valid attributes' do
      let(:question_params) { attributes_for(:question) }

      it 'saves a new question in database' do
        expect { post_create }.to change(Question, :count).by(1)
      end

      it 'redirect to created question' do
        post_create
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      let(:question_params) { attributes_for(:question, :invalid) }

      it 'didn`t save question' do
        expect { post_create }.not_to change(Question, :count)
      end

      it 'render new view' do
        post_create
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'delete users question' do
      let!(:own_question) { create(:question, author: user) }
      let(:delete_destroy) { delete :destroy, params: { id: own_question } }

      it 'destroy question' do
        expect { delete_destroy }.to change(Question, :count).by(-1)
      end

      it 'redirect to all questions' do
        delete_destroy

        expect(response).to redirect_to questions_path
      end
    end

    context 'delete unfamiliar question' do
      let!(:question) { create(:question) }
      let(:delete_destroy) { delete :destroy, params: { id: question } }

      it "don't destroy question" do
        expect { delete_destroy }.not_to change(Question, :count)
      end

      it 'render question' do
        delete_destroy

        expect(response).to redirect_to question
      end
    end
  end
end
