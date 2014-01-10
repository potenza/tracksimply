class Data::SitesController < ApplicationController
  before_action :require_user

  def visits_and_conversions
    site = Site.find(params[:id])
    chart = VisitsAndConversionsChart.new(site, current_user.time_zone)
    render json: chart.data.to_json
  end
end
