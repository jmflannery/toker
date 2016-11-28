module Toker
  class ApplicationController < ActionController::API
    include ActionController::HttpAuthentication::Basic::ControllerMethods
    include Toker::TokenAuthentication
  end
end
