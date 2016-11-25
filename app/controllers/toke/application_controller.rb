module Toke
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session

    include Toke::TokenAuthentication
  end
end
