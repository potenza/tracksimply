class Track::ConversionsController < ApplicationController
  attr_reader :visitor

  def index
    set_visitor
    click = visitor.most_recent_click

    # setting @conversion for testing (seems hacky)
    @conversion = click.create_conversion(
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
