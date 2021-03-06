class APIController < ApplicationController
  before_action :authenticate_user
  before_action :default_format_json

  def authenticate_user
    render json: {}, status: 401 unless valid_token?
  end

  protected

  def valid_token?
    !current_administrateur.nil?
  end

  def current_administrateur
    @administrateur ||= Administrateur.find_by_api_token(params[:token])
  end

  def default_format_json
    request.format = 'json' unless request.params[:format]
  end
end
