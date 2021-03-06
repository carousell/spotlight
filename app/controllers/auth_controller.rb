class AuthController < ApplicationController
  skip_before_action :authenticate_user, only: [:login, :get_auth_token]
  skip_before_action :verify_authenticity_token, only: [:login, :get_auth_token]

  def get_auth_token
    token_info = get_token_info(auth_params)

    if for_spotlight?(token_info) && for_host_domain?(token_info)
      user = User.find_or_create_by(email: token_info.email)

      render json: {auth_token: user.auth_token}, status: :created
    else
      render json: {error: 'This user is not a member of the host domain.'}, status: :forbidden
    end
  rescue Google::Apis::ClientError
    render json: {error: 'Invalid token'}, status: :forbidden
  end

  def login
    redirect_url = login_params.fetch(:redirect_url)
    auth_token = login_params.fetch(:auth_token)

    if User.exists?(auth_token: auth_token)
      session[:current_user] = User.find_by(auth_token: auth_token)
      redirect_to redirect_url
    else
      redirect_to ENV.fetch('WEB_HOST')
    end
  end

  private

  def login_params
    params.permit(:redirect_url, :auth_token)
  end

  def auth_params
    params.permit(:id_token)
  end

  def get_token_info(params)
    GoogleTokenInfoService.new.get_token_info params.fetch(:id_token)
  end

  def for_spotlight?(token_info)
    token_info.audience == ENV.fetch('GOOGLE_API_CLIENT_ID')
  end

  def for_host_domain?(token_info)
    token_info.email.ends_with?("@#{ENV.fetch('GOOGLE_HOST_DOMAIN')}")
  end
end
