class SiteStatsController
  setup: ->
    @destroyEventHandlers()
    @setEventHandlers()
    @setDefaultDates()

  destroyEventHandlers: ->
    $(".date-picker").datepicker().off "changeDate"
    $(document).off "click", "[data-date-shortcut]"
    $(document).off "change", "select#medium"

  setEventHandlers: ->
    $(".date-picker").datepicker(
      format: "mm/dd/yyyy"
    ).on "changeDate", (e) =>
      @updateCharts()

    $(document).on "click", "[data-date-shortcut]", (e) =>
      e.preventDefault()
      @dateRangeShortcut($(e.target).data("date-shortcut"))

    $(document).on "change", "select#medium", (e) =>
      e.preventDefault()
      @updateCharts()

  setDefaultDates: ->
    startDate = Date.today().add(-29).days()
    endDate = Date.today()
    @setDates(startDate, endDate)

  setDates: (startDate, endDate) ->
    $("#start-date").datepicker("update", startDate.toString("MM/dd/yyyy"))
    $("#end-date").datepicker("update", endDate.toString("MM/dd/yyyy"))
    @updateCharts()

  updateCharts: =>
    $(".date-picker").datepicker("hide")
    try
      startDate = Date.parse($("#start-date").val()).toString("yyyy-MM-dd")
      endDate = Date.parse($("#end-date").val()).toString("yyyy-MM-dd")
      medium = $("#medium").val()
      @displayVisitorChart(startDate, endDate, medium)
      @displayMediaTable(startDate, endDate, medium)
    catch e
      console.log "SiteStatsController: error parsing date [startDate: #{$("#start-date").val()}], [endDate: #{$("#end-date").val()}]"

  displayVisitorChart: (startDate, endDate, medium) ->
    $chart = $(".site-visitor-chart")
    $.getJSON $chart.data("url"), { start_date: startDate, end_date: endDate, medium: medium }, (data) ->
      App.visitorsChart.setup($chart, data.visits, data.conversions)

  displayMediaTable: (startDate, endDate, medium) ->
    $table = $(".site-media-table")
    $body = $(".site-media-table tbody")
    $body.empty()
    $.getJSON $table.data("url"), { start_date: startDate, end_date: endDate, medium: medium }, (data) ->
      tpl = $("#site-medium-template").html()
      $body.append(tmpl(tpl, stats)) for stats in data

  dateRangeShortcut: (shortcut) ->
    if shortcut == "today"
      startDate = endDate = Date.parse("t")
    else if shortcut == "yesterday"
      startDate = endDate = Date.parse("t-1")
    else if shortcut == "last-7-days"
      startDate = Date.parse("t-6")
      endDate = Date.parse("t")
    else if shortcut == "last-30-days"
      startDate = Date.parse("t-29")
      endDate = Date.parse("t")
    else if shortcut == "this-month"
      startDate = Date.today().clearTime().moveToFirstDayOfMonth()
      endDate = Date.today().clearTime().moveToLastDayOfMonth()
    else if shortcut == "this-month"
      startDate = Date.today().clearTime().moveToFirstDayOfMonth()
      endDate = Date.today().clearTime().moveToLastDayOfMonth()
    else if shortcut == "last-month"
      startDate = Date.parse("m-1").clearTime().moveToFirstDayOfMonth()
      endDate = Date.parse("m-1").clearTime().moveToLastDayOfMonth()

    @setDates(startDate, endDate)

App.siteStatsController = new SiteStatsController
