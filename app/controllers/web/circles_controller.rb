class Web::CirclesController < ApplicationController
  before_action :authenticate_user!

  def index
    # Optionally: show only circles relevant to user's stage
    @circles = Circle.all
  end

  def show
  end
end
