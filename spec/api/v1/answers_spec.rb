describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/answers/:id' do
    let!(:answer) { create(:answer) }
    let!(:links) { create_list(:link, 3, linkable: answer) }
    let!(:comments) { create_list(:comment, 3, commentable: answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      before do
        answer.files.attach(io: File.open("#{Rails.root}/config/storage.yml"), filename: 'storage.yml')
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body question_id author_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      describe 'links' do
        let(:link_response) { answer_response['short_links'] }

        it 'returns list of links' do
          expect(link_response.size).to eq 3
        end

        it 'returns attributes' do
          %w[url name].each do |attr|
            expect(link_response.first[attr]).to eq answer.links.first.send(attr).as_json
          end
        end
      end

      describe 'comments' do
        let(:comment_response) { answer_response['short_comments'] }

        it 'returns list of comments' do
          expect(comment_response.size).to eq 3
        end

        it 'returns all attributes' do
          %w[id text author_id created_at updated_at].each do |attr|
            expect(comment_response.first[attr]).to eq answer.comments.first.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:files_response) { answer_response['files_urls'] }

        it 'returns list of files' do
          expect(files_response.size).to eq 1
        end

        it 'returns url' do
          expect(files_response.first['url']).to eq answer.files.first.send('url').as_json
        end
      end
    end
  end
end
