class Api::SitesController < ApplicationController
  before_action :require_user

  def graph
    site = Site.find(params[:id])
    stats = SiteDailyActivity.new(site, current_user.time_zone, params[:start_date], params[:end_date], params[:filters]).query
    render json: SiteGraphPresenter.new(params[:start_date], params[:end_date], stats).data.to_json
  end

  def table
    site = Site.find(params[:id])
    aggregate_by = params[:aggregate_by]
    aggregate_by = "medium" if aggregate_by == "media"
    stats = SitePerformanceAggregator.new(site, current_user.time_zone, params[:start_date], params[:end_date], aggregate_by, params[:filters]).query
    render json: SiteTablePresenter.new(stats).data.to_json
  end
end
