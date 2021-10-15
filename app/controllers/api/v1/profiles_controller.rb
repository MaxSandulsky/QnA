class Api::V1::ProfilesController < Api::V1::BaseController
  load_and_authorize_resource class: User

  def me
    render json: current_resource_owner
  end
end
