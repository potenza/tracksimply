$(document).on "keyup", ".site-conversion-code .form-control", (e) ->
  $(".site-conversion-code .well span").html($(".site-conversion-code .form-control").val())

ready = ->
  if $(".site-media-table").length > 0
    $("[data-toggle=tooltip]").tooltip()

$(document).ready ready
$(document).on "page:load", ready
