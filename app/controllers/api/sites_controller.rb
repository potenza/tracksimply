class Api::SitesController < ApplicationController
  before_action :require_user

  def media_chart
    media = params[:media] || TrackingLink::MEDIA

    site = Site.find(params[:id])
    chart = MediaChart.new(site, time_zone: current_user.time_zone)
    render json: chart.query(media, params[:start_date], params[:end_date]).to_json
  end

  def visitors_chart
    site = Site.find(params[:id])
    chart = VisitorsChart.new(site, time_zone: current_user.time_zone)
    render json: chart.query(params[:start_date], params[:end_date]).to_json
  end
end
