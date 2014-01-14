window.Tracksimply.Charts.Visitors = ($elem, visits, conversions) ->
  max = Math.max.apply(this, visits.map((visit) -> parseInt(visit[1])))
  max = 3 if max == 0

  $elem.highcharts
    title:
      text: false

    legend:
      enabled: false

    xAxis:
      type: 'datetime'

    yAxis:
      min: 0
      max: max
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
      minPointLength: 8
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
