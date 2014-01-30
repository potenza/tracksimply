class SitesController < ApplicationController
  before_action :require_user
  before_action :require_admin, except: [:index, :show]

  def index
    @sites = sites
  end

  def new
    @site = Site.new
  end

  def create
    @site = Site.new(site_params)
    if @site.save
      redirect_to @site, notice: "#@site has been added"
    else
      render :new
    end
  end

  def show
    @site = Site.find(params[:id])
    @visits = @site.visits.includes(:tracking_link, :conversion)
    @start_date = Date.parse(params[:start_date]) rescue Time.now.in_time_zone(User.first.time_zone).to_date - 29.days
    @end_date = Date.parse(params[:end_date]) rescue Time.now.in_time_zone(User.first.time_zone).to_date
    @aggregate_by = params[:aggregate_by] || "media"
    @filters = params[:filters]
  end

  def pixel
    @site = Site.find(params[:id])
  end

  def edit
    @site = Site.find(params[:id])
  end

  def update
    @site = Site.find(params[:id])
    if @site.update_attributes(site_params)
      redirect_to @site, notice: "#@site has been updated"
    else
      render :edit
    end
  end

  def destroy
    site = Site.find(params[:id])
    site.destroy
    redirect_to sites_path, notice: "#{site} has been deleted"
  end

  private

  def site_params
    params.require(:site).permit(:name)
  end
end
