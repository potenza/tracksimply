class Api::SitesController < ApplicationController
  before_action :require_user

  def visitors_chart
    medium = params[:medium].present? && params[:medium] || nil

    site = Site.find(params[:id])
    chart = VisitorsChart.new(site, current_user.time_zone)
    render json: chart.query(params[:start_date], params[:end_date], medium).to_json
  end

  def media_chart
    site = Site.find(params[:id])
    chart = MediaChart.new(site, current_user.time_zone)
    render json: chart.query(params[:start_date], params[:end_date]).to_json
  end

  def medium_chart
    site = Site.find(params[:id])
    chart = MediumChart.new(site, current_user.time_zone)
    render json: chart.query(params[:medium], params[:start_date], params[:end_date]).to_json
  end
end
