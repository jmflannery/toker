class ApplicationController < ActionController::API
  include Toker::TokenAuthentication
end
