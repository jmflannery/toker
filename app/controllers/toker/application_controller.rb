module Toker
  class ApplicationController < ActionController::API
    include ActionController::HttpAuthentication::Basic::ControllerMethods
    include ActionController::HttpAuthentication::Basic::ControllerMethods::ClassMethods
    include Toker::TokenAuthentication
  end
end
