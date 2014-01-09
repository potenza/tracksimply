$(document).on "page:load", (e) ->
  combineTrackingLinksFields()

$ ->
  combineTrackingLinksFields()

combineTrackingLinksFields = ->
  if $(".combine-tracking-link-fields").length > 0
    protocol = $("#tracking_link_landing_page_protocol").parent().html()
    $("#tracking_link_landing_page_url").parent().prepend(protocol)
    $(".combine-tracking-link-fields").find(".form-group").first().remove()
