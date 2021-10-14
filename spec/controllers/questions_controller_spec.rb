RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

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

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'populates all answers related to question' do
      expect(assigns(:answers).reject(&:new_record?)).to match_array(question.answers.reload)
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns a new link to @link' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns a new reward' do
      expect(assigns(:question).reward).to be_a_new(Reward)
    end

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
  end

  describe 'PATCH #update' do
    let(:patch_update) { patch :update, params: question_params, format: :js }
    let!(:own_question) { create(:question, author: user) }
    let!(:question) { create(:question) }

    context 'with valid attributes' do
      let(:question_params) { { id: own_question, question: { title: 'edited question title', body: 'edited question body' } } }

      it 'should change question attributes' do
        expect { patch_update }.to change{ own_question.reload.body }.to('edited question body')
                               .and change{ own_question.reload.title }.to('edited question title')
      end

      it 'should render update view' do
        patch_update

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      let(:question_params) { { id: own_question, question: { title: '', body: '' } } }

      it 'shouldn`t change question attributes' do
        expect { patch_update }.to not_change{ own_question.reload.body }
                               .and not_change{ own_question.reload.title }
      end

      it 'should render update view' do
        patch_update

        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #remove_attachment' do
    let!(:own_question) { create(:question, author: user) }
    let!(:question) { create(:question) }

    it 'should remove file from own_question' do
      own_question.files.attach(io: File.open("#{Rails.root}/config/storage.yml"), filename: 'storage.yml')

      expect {
        patch :remove_attachment, params: { id: own_question, attachment_id: own_question.files.first.id }, format: :js
             }.to change(own_question.files, :count).by(-1)
    end
  end
end
