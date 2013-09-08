module Toke
  class SessionsController < ApplicationController

    def create
      user = User.find_by_username(params[:session][:username])   
      if user && user.authenticate(params[:session][:password])
        user.token.toke
        render json: user.token, status: 201
      end
    end
  end
end
