class Data::SitesController < ApplicationController
  before_action :require_user

  def visits_and_conversions
    site = Site.find(params[:id])
    chart = VisitsAndConversionsChart.new(site)
    render json: chart.data.to_json
  end
end
