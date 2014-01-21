ready = ->
  if $(".imports-auto-refresh").length > 0
    setTimeout (-> location.reload()), 3000

$(document).ready ready
$(document).on "page:load", ready
