class Api::SitesController < ApplicationController
  before_action :require_user

  def media_chart
    medium = params[:medium].present? && params[:medium] || TrackingLink::MEDIA

    site = Site.find(params[:id])
    chart = MediaChart.new(site, time_zone: current_user.time_zone)
    render json: chart.query(medium, params[:start_date], params[:end_date]).to_json
  end

  def visitors_chart
    medium = params[:medium].present? && params[:medium] || nil

    site = Site.find(params[:id])
    chart = VisitorsChart.new(site, time_zone: current_user.time_zone)
    render json: chart.query(params[:start_date], params[:end_date], medium).to_json
  end
end
