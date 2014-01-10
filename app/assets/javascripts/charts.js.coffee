window.TrackSimply.Charts.VisitsAndConversions = ($elem, visits, conversions) ->
  $elem.highcharts
    title:
      text: 'Visits & Conversions'

    legend:
      enabled: false

    xAxis:
      type: 'datetime'

    yAxis:
      gridLineColor: '#f9f9f9'
      title:
        enabled: false

    tooltip:
      xDateFormat: '%b %e, %Y'
      pointFormat: '{series.name}: <b>{point.y}</b><br/>'

    series: [
      type: 'column'
      name: 'Visits'
      color: '#c0e5f5'
      states:
        hover:
          color: '#c0e5f5'
      data: visits
    ,
      type: 'spline'
      name: 'Conversions'
      lineWidth: 4
      color: '#328ed2'
      marker:
        lineWidth: 4
        lineColor: '#328ed2'
        fillColor: 'white'
      data: conversions
    ]
