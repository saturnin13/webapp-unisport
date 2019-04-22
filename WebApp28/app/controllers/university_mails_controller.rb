class UniversityMailsController < ApplicationController
  # No authentification needed to get universities
  skip_before_action :authenticate_user!, :only => [:index]

  GET_ALL_UNIVERSITIES =
    "SELECT DISTINCT university_name
     FROM university_mails;"

  def index
    @universities =
      ActiveRecord::Base.connection.execute(GET_ALL_UNIVERSITIES)

    respond_to do |format|
      format.json { render json: @universities }
    end
  end
end
