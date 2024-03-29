RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:own_answer) { create(:answer, question: question, author: user) }

  before { login(user) }

  describe 'POST #create' do
    let(:post_create) { post :create, params: { question_id: question, answer: answer_params }, format: :js }

    context 'with valid attributes' do
      let(:answer_params) { attributes_for(:answer) }

      it 'saves a new answer in database' do
        expect { post_create }.to change(question.answers, :count).by(1)
      end

      it 'renders create view' do
        post_create

        expect(response).to render_template 'answers/_answer'
      end
    end

    context 'with invalid attributes' do
      let(:answer_params) { attributes_for(:answer, :invalid) }

      it 'didn`t save answer' do
        expect { post_create }.not_to change(question.answers, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let(:patch_update) { patch :update, params: answer_params, format: :js }

    context 'with valid attributes' do
      let(:answer_params) { { id: own_answer, answer: { body: 'edited answer' } } }

      it 'changes answer attributes' do
        expect { patch_update }.to change { own_answer.reload.body }.to 'edited answer'
      end

      it 'renders update view' do
        patch_update

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      let(:answer_params) { { id: own_answer, answer: { body: '' } } }

      it 'shouldn`t change answer attributes' do
        expect { patch_update }.not_to change { own_answer.reload.body }
      end

      it 'renders update view' do
        patch_update

        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_destroy) { delete :destroy, params: answer_params, format: :js }

    context 'delete users answer' do
      let(:answer_params) { { id: own_answer } }

      it 'destroy answer' do
        expect { delete_destroy }.to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
        delete_destroy

        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #remove_attachment' do
    it 'removes file from own_answer' do
      own_answer.files.attach(io: File.open("#{Rails.root}/config/storage.yml"), filename: 'storage.yml')

      expect do
        patch :remove_attachment, params: { id: own_answer, attachment_id: own_answer.files.first.id }, format: :js
      end.to change(own_answer.files, :count).by(-1)
    end
  end
end
