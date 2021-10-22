describe 'Profiles API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:me_response) { json['me'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(me_response[attr]).to eq me.send(attr).as_json
        end
      end

      it 'doesnot returns private fields' do
        %w[password encrypted_password].each do |attr|
          expect(me_response).not_to have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:all_response) { json['profiles'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns profiles of all users except user`s' do
        expect(all_response.count).to eq 3
        all_response.each do |user|
          expect(users.find { |u| u.id == user['id'] }).not_to be_nil
        end
      end

      it 'returns all public fields' do
        all_response.each do |user|
          %w[id email admin created_at updated_at].each do |attr|
            expect(user).to have_key(attr)
          end
        end
      end

      it 'doesnot returns private fields' do
        all_response.each do |user|
          %w[password encrypted_password].each do |attr|
            expect(user).not_to have_key(attr)
          end
        end
      end
    end
  end
end
