class Track::ConversionsController < ApplicationController
  attr_reader :visitor

  def index
    set_visitor
    visit = visitor.most_recent_visit

    # setting @conversion for testing (seems hacky)
    @conversion = visit.create_conversion(
      revenue: params[:revenue]
    )

    # transparent pixel
    send_data(
      Base64.decode64("R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="),
      type: "image/gif",
      disposition: "inline"
    )
  end

  private

  def set_visitor
    @visitor = Visitor.find(cookies.permanent.signed[:v_id])
  end
end
