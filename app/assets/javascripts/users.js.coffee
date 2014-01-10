$(document).on "page:load", (e) ->
  fixTimeZone()

$ ->
  fixTimeZone()

fixTimeZone = ->
  $time_zone = $("#user_time_zone")
  $time_zone.addClass("form-control") if $time_zone.length > 0
