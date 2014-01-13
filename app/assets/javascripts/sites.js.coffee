$(document).on "keyup", ".site-conversion-code .form-control", (e) ->
  $(".site-conversion-code .well span").html($(".site-conversion-code .form-control").val())

ready = ->
  displayDefaultCharts()

displayDefaultCharts = ->
  if $(".site-visitor-chart").length > 0
    startDate = Date.today().add(-29).days().toString("yyyy-MM-dd")
    endDate = Date.today().toString("yyyy-MM-dd")
    displayVisitorChart(startDate, endDate)
    displayMediaTable(startDate, endDate)

displayVisitorChart = (startDate, endDate) ->
  $chart = $(".site-visitor-chart")
  $.getJSON $chart.data("url"), { start_date: startDate, end_date: endDate }, (data) ->
    Tracksimply.Charts.Visitors($chart, data.visits, data.conversions)

displayMediaTable = (startDate, endDate) ->
  $table = $(".site-media-table")
  $body = $(".site-media-table tbody")
  $body.empty()
  $.getJSON $table.data("url"), { start_date: startDate, end_date: endDate }, (data) ->
    tpl = $("#site-medium-template").html()
    $body.append(tmpl(tpl, stats)) for stats in data

$(document).ready ready
$(document).on "page:load", ready
