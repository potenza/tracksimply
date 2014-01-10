$(document).on "keyup", ".site-conversion-code .form-control", (e) ->
  $(".site-conversion-code .well span").html($(".site-conversion-code .form-control").val())

$(document).on "page:load", (e) ->
  displayCharts()

$ ->
  displayCharts()

displayCharts = ->
  $chart = $(".site-main-chart")
  if $chart.length > 0
    startDate = Date.today().add(-29).days().toString("yyyy-MM-dd")
    endDate = Date.today().toString("yyyy-MM-dd")

    $.getJSON $chart.data("url"), { start_date: startDate, end_date: endDate }, (data) ->
      TrackSimply.Charts.Visitors($chart, data.visits, data.conversions)
