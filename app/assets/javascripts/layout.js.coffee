ready = ->
  if $(".alerts").length > 0
    f = -> $(".alerts").fadeOut()
    setTimeout f, 1000

$(document).ready ready
$(document).on "page:load", ready
