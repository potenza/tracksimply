$(document).on "keyup", ".site-conversion-code .form-control", (e) ->
  $(".site-conversion-code .well span").html($(".site-conversion-code .form-control").val())

$(document).on "page:load", (e) ->
  displayCharts()

$ ->
  displayCharts()

displayCharts = ->
  $chart = $(".site-main-chart")
  if $chart.length > 0
    $.getJSON $chart.data("url"), (data) ->
      TrackSimply.Charts.VisitsAndConversions($chart, data.visits, data.conversions)
