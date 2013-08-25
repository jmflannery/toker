require_dependency "toke/application_controller"

module Toke

  class UsersController < ApplicationController

    def create
      user = User.new(person_params)
      head user.valid? ? 201 : 500
    end

    def person_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end
  end
end
