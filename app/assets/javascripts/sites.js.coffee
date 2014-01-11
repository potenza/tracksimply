$(document).on "keyup", ".site-conversion-code .form-control", (e) ->
  $(".site-conversion-code .well span").html($(".site-conversion-code .form-control").val())

$(document).on "page:load", (e) ->
  displayCharts()

$ ->
  displayCharts()

displayCharts = ->
  $chart = $(".site-visitor-chart")
  $table = $(".site-media-table")

  if $chart.length > 0
    startDate = Date.today().add(-29).days().toString("yyyy-MM-dd")
    endDate = Date.today().toString("yyyy-MM-dd")

    $.getJSON $chart.data("url"), { start_date: startDate, end_date: endDate }, (data) ->
      TrackSimply.Charts.Visitors($chart, data.visits, data.conversions)

  if $table.length > 0
    $body = $(".site-media-table tbody")
    $.getJSON $table.data("url"), { start_date: startDate, end_date: endDate }, (data) ->
      tpl = $("#site-medium-template").html()
      $body.append(tmpl(tpl, stats)) for stats in data
