module Toke

  class UsersController < ApplicationController

    before_action :toke, only: :create

    def create
      user = User.new(person_params)
      if user.save
        render json: user, status: 201
      else
        head 500
      end
    end

    def index
      render json: User.all
    end

    def show
      user = User.find(params[:id])
      render json: user
    end

    private

    def person_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end
  end
end
