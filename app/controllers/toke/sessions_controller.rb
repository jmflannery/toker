module Toke
  class SessionsController < ApplicationController

    before_action :toke, only: :destroy

    def create
      user = User.find_by_username(params[:session][:username])   
      if user && user.authenticate(params[:session][:password])
        user.toke
        render json: user, status: 201
      else
        head :unauthorized
      end
    end

    def destroy
      token = Token.find_by(id: params[:id])
      if token
        token.destroy
        head :no_content
      else
        head :not_found
      end
    end
  end
end
