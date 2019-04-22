class SportsController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:index]

  def index
    get_sports_query =
      "SELECT DISTINCT sports.name
       FROM sports;"

    @sports = ActiveRecord::Base.connection.execute(get_sports_query)

    respond_to do |format|
      format.json { render json: @sports }
    end
  end

end
