class TrackingLinkController
  setup: ->
    @destroyEventHandlers()
    @setEventHandlers()
    @init()

  destroyEventHandlers: ->
    $(document).off "submit", "#tracking_link_form"
    $(document).off "change", "#tracking_link_cost_attributes_type"

  setEventHandlers: ->
    $(document).on "submit", "#tracking_link_form", (e) =>
      @updateDestroyField()
      @formatDates("yyyy-MM-dd")
      true

    $(document).on "change", "#tracking_link_cost_attributes_type", (e) =>
      @toggleMonthlyCostFields()
      @updateDestroyField()

  init: ->
    @formatDates("MM/dd/yyyy")
    $(".datepicker").datepicker(format: "mm/dd/yyyy")
    @toggleMonthlyCostFields()

  formatDates: (format) ->
    for attr in ["start_date", "end_date"]
      date = $("#tracking_link_cost_attributes_#{attr}").val()
      if date
        date = Date.parse(date).toString(format)
        $("#tracking_link_cost_attributes_#{attr}").val(date)

  costType: ->
    $("#tracking_link_cost_attributes_type").val()

  toggleMonthlyCostFields: ->
    type = @costType()
    if type == "MonthlyCost"
      $("#monthly-cost-start-date label").text("Start Date")
      $("#monthly-cost-start-date").removeClass("hide")
      $("#monthly-cost-end-date").removeClass("hide")
    else if type == "OneTimeCost"
      $("#monthly-cost-start-date label").text("Payment Date")
      $("#monthly-cost-start-date").removeClass("hide")
      $("#monthly-cost-end-date").addClass("hide")
    else
      $("#monthly-cost-start-date").addClass("hide")
      $("#monthly-cost-end-date").addClass("hide")

  updateDestroyField: ->
    if @costType() == ""
      $("#tracking_link_cost_attributes__destroy").val("1")
      $("#tracking_link_cost_attributes_amount").val("")
    else
      $("#tracking_link_cost_attributes__destroy").val("false")

App.TrackingLinkController = new TrackingLinkController
