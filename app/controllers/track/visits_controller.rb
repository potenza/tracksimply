class Track::VisitsController < ApplicationController
  attr_reader :visitor

  def new
    tracking_link = TrackingLink.includes(:site).find_by!(token: params[:token])
    set_visitor

    # setting @visit for tests. seems hacky
    @visit = Visit.create(
      site: tracking_link.site,
      tracking_link: tracking_link,
      visitor: visitor,
      details: {
        keyword: params[:kw],
        ip_address: request.remote_ip,
        referrer: request.referer
      }
    )

    redirect_to tracking_link.landing_page_url
  end

  private

  def set_visitor
    @visitor = Visitor.find(cookies.permanent.signed[:v_id]) if cookies.signed[:v_id]
    unless @visitor
      @visitor = Visitor.create
      cookies.permanent.signed[:v_id] = @visitor.id
    end
  end
end
