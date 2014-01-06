class TrackingLinksController < ApplicationController
  before_action :require_user, :require_admin, :set_site

  def index
    @tracking_links = @site.tracking_links
  end

  def new
    @tracking_link = TrackingLink.new
  end

  def create
    @tracking_link = @site.tracking_links.build(tracking_link_params)
    if @tracking_link.save
      redirect_to site_tracking_link_path(@site, @tracking_link), notice: "Tracking link #@tracking_link has been added"
    else
      render :new
    end
  end

  def show
    @tracking_link = @site.tracking_links.find(params[:id])
  end

  def edit
    @tracking_link = @site.tracking_links.find(params[:id])
  end

  def update
    @tracking_link = @site.tracking_links.find(params[:id])
    if @tracking_link.update_attributes(tracking_link_params)
      redirect_to site_tracking_link_path(@site, @tracking_link), notice: "Tracking link #@tracking_link has been updated"
    else
      render :edit
    end
  end

  def destroy
    tracking_link = @site.tracking_links.find(params[:id])
    tracking_link.destroy
    redirect_to site_tracking_links_path(@site), notice: "Tracking link #{tracking_link} has been deleted"
  end

  private

  def set_site
    @site = Site.find(params[:site_id])
  end

  def tracking_link_params
    params.require(:tracking_link).permit(:landing_page_url, :campaign, :source, :medium, :ad_content, :token, :sid, :cost_type, :cost)
  end
end
