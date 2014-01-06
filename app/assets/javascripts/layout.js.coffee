$(document).on "page:load", (e) ->
  hideAlerts()

$ ->
  hideAlerts()

hideAlerts = ->
  if $(".alerts").length > 0
    f = -> $(".alerts").fadeOut()
    setTimeout f, 1000
