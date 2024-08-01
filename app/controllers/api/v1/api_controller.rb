class Api::V1::ApiController < ApplicationController
  include Api::V1::Authenticatable
  protect_from_forgery with: :null_session
  respond_to :json
end