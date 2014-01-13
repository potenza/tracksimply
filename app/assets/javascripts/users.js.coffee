ready = ->
  $time_zone = $("#user_time_zone")
  $time_zone.addClass("form-control") if $time_zone.length > 0

$(document).ready ready
$(document).on "page:load", ready
