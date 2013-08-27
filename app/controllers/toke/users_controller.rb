require_dependency "toke/application_controller"

module Toke

  class UsersController < ApplicationController

    def create
      user = User.new(person_params)
      if user.save
        render json: user.as_json, status: 201
      else
        head 500
      end
    end

    def person_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end
  end
end
