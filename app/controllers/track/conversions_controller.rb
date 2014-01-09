class Track::ConversionsController < ApplicationController
  def index
    if visitor = Visitor.find_by_id(cookies.permanent.signed[:v_id])
      visit = visitor.most_recent_visit

      # setting @conversion for testing (seems hacky)
      @conversion = visit.create_conversion(
        revenue: params[:revenue]
      )
    end

    # transparent pixel
    send_data(
      Base64.decode64("R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="),
      type: "image/gif",
      disposition: "inline"
    )
  end
end
