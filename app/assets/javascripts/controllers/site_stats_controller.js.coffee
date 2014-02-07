class SiteStatsController
  setup: ->
    @destroyEventHandlers()
    @setEventHandlers()
    @displayCharts()

  destroyEventHandlers: ->
    $(document).off "click", ".date-display"
    $(document).off "click", ".date-selectors .close"
    $(document).off "click", ".date-selectors .pickers .btn"
    $(document).off "click", "[data-date-shortcut]"
    $(document).off "click", ".aggregate-by a"
    $(document).off "click", ".site-table *[data-filter]"
    $(document).off "click", ".filters a"

  setEventHandlers: ->
    $(".date-picker").datepicker(format: "mm/dd/yyyy", autoclose: true)

    $(document).on "click", ".date-display", (e) =>
      console.log "date-display"
      e.preventDefault()
      @displayDateSelectors()

    $(document).on "click", ".date-selectors .close", (e) =>
      e.preventDefault()
      @hideDateSelectors()

    $(document).on "click", ".date-selectors .pickers .btn", (e) =>
      e.preventDefault()
      @requestNewPage()

    $(document).on "click", "[data-date-shortcut]", (e) =>
      e.preventDefault()
      @applyDateShortcut($(e.target).data("date-shortcut"))

    $(document).on "click", ".aggregate-by a", (e) =>
      e.preventDefault()
      @highlightAggregateBy($(e.target))

    $(document).on "click", ".site-table *[data-filter]", (e) =>
      e.preventDefault()
      @applyFilter($(e.target).data("filter-type"), $(e.target).data("filter"))

    $(document).on "click", ".filters a", (e) =>
      e.preventDefault()
      @removeFilter($(e.target).parent().data("filter-type"))

  displayDateSelectors: ->
    $(".date-selectors").removeClass("hide")

  hideDateSelectors: ->
    $(".date-selectors").addClass("hide")

  getStartDate: ->
    Date.parse($("#start-date").val()).toString("yyyy-MM-dd")

  getEndDate: ->
    Date.parse($("#end-date").val()).toString("yyyy-MM-dd")

  getAggregateBy: ->
    $(".aggregate-by .active a").data("aggregate-by")

  getFilters: ->
    [$(span).data("filter-type"), $(span).data("filter")] for span in $(".filters span")

  # request a new page so it's added to browser history and the report can easily be shared via URL
  requestNewPage: ->
    url = "?start_date=#{@getStartDate()}" +
          "&end_date=#{@getEndDate()}" +
          "&aggregate_by=#{@getAggregateBy()}"
    filters =  ("filters[#{filter[0]}]=#{encodeURIComponent(filter[1])}" for filter in @getFilters()).join("&")
    url += "&#{filters}" if filters
    location.href = url

  applyDateShortcut: (shortcut) ->
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

    $("#start-date").datepicker("update", startDate.toString("MM/dd/yyyy"))
    $("#end-date").datepicker("update", endDate.toString("MM/dd/yyyy"))
    @requestNewPage()

  applyFilter: (filterType, filter) ->
    obj =
      type: filterType
      type_display: filterType.replace /_/g, ' '
      filter: filter
    tpl = $("#site-filter-template").html()
    $(".filters").append(tmpl(tpl, obj))
    @requestNewPage()

  removeFilter: (filterType) ->
    $(".filters").find("[data-filter-type=#{filterType}]").remove()
    @requestNewPage()

  highlightAggregateBy: ($target) ->
    $(".aggregate-by .active").removeClass("active")
    $target.parent().addClass("active")
    @requestNewPage()

  displayCharts: =>
    startDate = @getStartDate()
    endDate = @getEndDate()
    filters = {}
    filters[filter[0]] = filter[1] for filter in @getFilters()
    @displayGraph(startDate, endDate, filters)
    @displayTable(startDate, endDate, @getAggregateBy(), filters)

  displayGraph: (startDate, endDate, filters) ->
    $graph = $(".site-graph")
    $.getJSON $graph.data("url"), { start_date: startDate, end_date: endDate, filters: filters }, (data) ->
      App.VisitorsGraph.setup($graph, data.visits, data.conversions)

  displayTable: (startDate, endDate, aggregateBy, filters) ->
    $table = $(".site-table")
    $body = $(".site-table tbody").empty()
    $footer = $(".site-table tfoot").empty()
    $.getJSON $table.data("url"), { start_date: startDate, end_date: endDate, aggregate_by: aggregateBy, filters: filters }, (data) =>
      tpl = $("#site-table-row-template").html()
      for stats in data
        if stats.type == "totals"
          $footer.append(tmpl(tpl.replace(/td/g, 'th'), stats)) # convert to tds to ths
          $footer.find('a').contents().unwrap() # remove <a />
        else
          $body.append(tmpl(tpl, stats))
      $table.find('a').filter(':contains("[empty]"), :contains("[other costs]")').contents().unwrap().parent().addClass("text-muted")
      $table.find(".aggregate-by").html($(".aggregate-by .active a").html())
      @formatMoney()
      @enableToolTips()

  formatMoney: ->
    for elem in $("tbody .money, tfoot .money")
      $elem = $(elem)
      $elem.text(accounting.formatMoney($elem.text()))

    for elem in $("tbody .profit, tfoot .profit")
      $elem = $(elem)
      $elem.removeClass("positive,negative")
      if $elem.text() == "$0.00"
        # don't do anything
      else if $elem.text().match /\$-/
        $elem.addClass("negative")
      else
        $elem.addClass("positive")

  enableToolTips: ->
    $("[data-toggle=tooltip]").tooltip()

App.SiteStatsController = new SiteStatsController
