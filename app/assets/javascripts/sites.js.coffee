$(document).on "keyup", ".site-conversion-code .form-control", (e) ->
  $(".site-conversion-code .well span").html($(".site-conversion-code .form-control").val())

ready = ->
  if $(".site-loading").length > 0
    f = -> $(".site-loading").fadeIn().show()
    setTimeout f, 250

$(document).ready ready
$(document).on "page:load", ready
