class ThingsController < ApplicationController
  before_action :toke!, only: :admin_index

  before_action only: :index do
    toke! do |errors|
      render json: Thing.published, status: 420
    end
  end

  def admin_index
    render json: Thing.all
  end

  def index
    render json: Thing.all
  end
end
