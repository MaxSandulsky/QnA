class Api::V1::ProfilesController < Api::V1::BaseController
  load_and_authorize_resource class: User

  def me
    render json: current_resource_owner, serializer: ProfileSerializer, root: 'me'
  end

  def index
    @profiles = User.others(current_user)
    render json: @profiles, serializer: ProfileSerializer, root: 'profiles'
  end
end
