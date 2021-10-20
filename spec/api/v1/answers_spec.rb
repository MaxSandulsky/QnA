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

  describe 'GET /api/v1/questions/:question_id/answers' do
    let!(:question) { create(:question_with_answers, answers_count: 3) }

    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answers_response) { json['answers'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(answers_response.size).to eq 3
      end

      it 'returns attributes' do
        %w[id body created_at updated_at author_id].each do |attr|
          expect(answers_response.first[attr]).to eq question.answers.first.send(attr).as_json
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      context 'valid attributes' do
        let(:answer_hash) do
          {
            question_id: question.id,
            body: "2",
            links_attributes: [
              {
                url: "https://github.com/CanCanCommunity/cancancan/tree/develop/docs",
                name: "123"
              },
              {
                url: "https://medium.com/@coorasse/eager-load-associations-with-parameters-in-rails-6e9fd7b65923",
                name: "1"
              },
              {
                url: "https://medium.com/@coorasse/eager-load-associations-with-parameters-in-rails-6e9fd7b65923",
                name: "2"
              }
            ]
          }
        end

        before { post api_path, params: { access_token: access_token.token, answer: answer_hash }, headers: headers }

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'returns all public fields' do
          %w[body question_id].each do |attr|
            expect(answer_response[attr]).to eq answer_hash[attr.to_sym]
          end
        end

        describe 'links' do
          let(:link_response) { answer_response['short_links'] }

          it 'returns list of links' do
            expect(link_response.size).to eq 3
          end

          it 'returns attributes' do
            %w[url name].each do |attr|
              expect(link_response.first[attr]).to eq answer_hash[:links_attributes].first[attr.to_sym]
            end
          end
        end
      end

      context 'invalid attributes' do
        let(:answer_hash) do
          {
            body: "",
            links_attributes: [
              {
                url: "",
                name: "123"
              },
              {
                url: "https://medium.com/@coorasse/eager-load-associations-with-parameters-in-rails-6e9fd7b65923",
                name: ""
              }
            ]
          }
        end

        before { post api_path, params: { access_token: access_token.token, answer: answer_hash }, headers: headers }

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'returns errors' do
          expect(json).to include "Body Тело ответа не может быть пустым!"
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:answer) { create(:answer, author: user) }
    let(:other_answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:answer_response) { json['answer'] }

      context 'valid attributes' do
        let(:answer_hash) do
          {
            body: "2",
            links_attributes: [
              {
                url: "https://github.com/CanCanCommunity/cancancan/tree/develop/docs",
                name: "123"
              },
              {
                url: "https://medium.com/@coorasse/eager-load-associations-with-parameters-in-rails-6e9fd7b65923",
                name: "1"
              },
              {
                url: "https://medium.com/@coorasse/eager-load-associations-with-parameters-in-rails-6e9fd7b65923",
                name: "2"
              }
            ]
          }
        end

        before { patch api_path, params: { access_token: access_token.token, answer: answer_hash }, headers: headers }

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'returns body' do
          expect(answer_response['body']).to eq answer_hash[:body]
        end

        describe 'links' do
          let(:link_response) { answer_response['short_links'] }

          it 'returns list of links' do
            expect(link_response.size).to eq 3
          end

          it 'returns attributes' do
            %w[url name].each do |attr|
              expect(link_response.first[attr]).to eq answer_hash[:links_attributes].first[attr.to_sym]
            end
          end
        end
      end

      context 'invalid attributes' do
        let(:answer_hash) do
          {
            body: "",
            links_attributes: [
              {
                url: "",
                name: "123"
              },
              {
                url: "https://medium.com/@coorasse/eager-load-associations-with-parameters-in-rails-6e9fd7b65923",
                name: ""
              }
            ]
          }
        end

        let(:patch_update) { patch api_path, params: { access_token: access_token.token, answer: answer_hash }, headers: headers }

        it 'returns 200 status' do
          patch_update
          expect(response).to be_successful
        end

        it 'returns errors' do
          expect{ patch_update }.not_to change { answer.reload.body }
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do

  end
end
