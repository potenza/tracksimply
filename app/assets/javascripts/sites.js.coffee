# date.js format strings
DATE_FORMAT_DISPLAY = "MM/dd/yyyy"
DATE_FORMAT_API = "yyyy-MM-dd"

$(document).on "keyup", ".site-conversion-code .form-control", (e) ->
  $(".site-conversion-code .well span").html($(".site-conversion-code .form-control").val())

$(document).on "click", "[data-date-shortcut]", (e) ->
  e.preventDefault()
  dateRangeShortcut($(e.target).data("date-shortcut"))

$(document).on "change", "select#medium", (e) ->
  e.preventDefault()
  updateCharts()

ready = ->
  if $(".site-visitor-chart").length > 0
    setDefaultDates()

setDefaultDates = ->
  $(".date-picker").datepicker(
    format: "mm/dd/yyyy" # different format string than date.js
  ).on "changeDate", (e) ->
    updateCharts()

  $("#start-date").datepicker("update", Date.today().add(-29).days().toString(DATE_FORMAT_DISPLAY))
  $("#end-date").datepicker("update", Date.today().toString(DATE_FORMAT_DISPLAY))
  updateCharts()

updateCharts = ->
  try
    startDate = Date.parse($("#start-date").val()).toString(DATE_FORMAT_API)
    endDate = Date.parse($("#end-date").val()).toString(DATE_FORMAT_API)
    medium = $("#medium").val()
    displayVisitorChart(startDate, endDate, medium)
    displayMediaTable(startDate, endDate, medium)
  catch e
    console.log "startDate: #{startDate}"
    console.log "endDate: #{endDate}"

displayVisitorChart = (startDate, endDate, medium) ->
  $chart = $(".site-visitor-chart")
  $.getJSON $chart.data("url"), { start_date: startDate, end_date: endDate, medium: medium }, (data) ->
    Tracksimply.Charts.Visitors($chart, data.visits, data.conversions)

displayMediaTable = (startDate, endDate, medium) ->
  $table = $(".site-media-table")
  $body = $(".site-media-table tbody")
  $body.empty()
  $.getJSON $table.data("url"), { start_date: startDate, end_date: endDate, medium: medium }, (data) ->
    tpl = $("#site-medium-template").html()
    $body.append(tmpl(tpl, stats)) for stats in data

dateRangeShortcut = (shortcut) ->
  if shortcut == "today"
    startDate = endDate = Date.parse('t')
  else if shortcut == "yesterday"
    startDate = endDate = Date.parse('t-1')
  else if shortcut == "last-7-days"
    startDate = Date.parse('t-6')
    endDate = Date.parse('t')
  else if shortcut == "last-30-days"
    startDate = Date.parse('t-29')
    endDate = Date.parse('t')
  else if shortcut == "this-month"
    startDate = Date.today().clearTime().moveToFirstDayOfMonth()
    endDate = Date.today().clearTime().moveToLastDayOfMonth()
  else if shortcut == "this-month"
    startDate = Date.today().clearTime().moveToFirstDayOfMonth()
    endDate = Date.today().clearTime().moveToLastDayOfMonth()
  else if shortcut == "last-month"
    startDate = Date.parse("m-1").clearTime().moveToFirstDayOfMonth()
    endDate = Date.parse("m-1").clearTime().moveToLastDayOfMonth()

  $("#start-date").val(startDate.toString(DATE_FORMAT_DISPLAY))
  $("#end-date").val(endDate.toString(DATE_FORMAT_DISPLAY))
  updateCharts()

$(document).ready ready
$(document).on "page:load", ready
