module Toke
  class ApplicationController < ActionController::API
    include ActionController::HttpAuthentication::Basic::ControllerMethods
    include Toke::TokenAuthentication
  end
end
