describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body author_id created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body question_id author_id correct created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create(:question_with_answers, answers_count: 3) }
    let!(:links) { create_list(:link, 3, linkable: question) }
    let!(:comments) { create_list(:comment, 3, commentable: question) }

    let(:api_path) { "/api/v1/questions/#{question.id}" }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      before do
        question.files.attach(io: File.open("#{Rails.root}/config/storage.yml"), filename: 'storage.yml')
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body author_id created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      describe 'answers' do
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body question_id author_id correct created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq question.answers.first.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:link_response) { question_response['short_links'] }

        it 'returns list of links' do
          expect(link_response.size).to eq 3
        end

        it 'returns attributes' do
          %w[url name].each do |attr|
            expect(link_response.first[attr]).to eq question.links.first.send(attr).as_json
          end
        end
      end

      describe 'comments' do
        let(:comment_response) { question_response['short_comments'] }

        it 'returns list of comments' do
          expect(comment_response.size).to eq 3
        end

        it 'returns all attributes' do
          %w[id text author_id created_at updated_at].each do |attr|
            expect(comment_response.first[attr]).to eq question.comments.first.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:files_response) { question_response['files_urls'] }

        it 'returns list of files' do
          expect(files_response.size).to eq 1
        end

        it 'returns url' do
          expect(files_response.first['url']).to eq question.files.first.send('url').as_json
        end
      end
    end
  end
end
