require_dependency "toke/application_controller"

module Toke
  class UsersController < ApplicationController

    def create
      render text: 'Toke'
    end
  end
end
