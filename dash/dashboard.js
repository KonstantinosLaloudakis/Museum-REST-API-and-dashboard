let data
let config
var date = new Date();
var dateFormat = date.getFullYear() + "-" + ((date.getMonth() + 1).toString().length != 2 ? "0" + (date.getMonth() + 1) : (date.getMonth() + 1)) + "-" + (date.getDate().toString().length != 2 ? "0" + date.getDate() : date.getDate());
var hours = [];
for (i = 0; i < 24; i++) {
  hours.push(('0' + i).slice(-2));
}

function setDefaultDateValues() { 
  document.getElementById("dateFrom").value = dateFormat;
  document.getElementById("dateTo").value = dateFormat;
}

function visitPerHour() {
  $.ajax({
    type: 'get',
    url: 'graph.php',
    data: { query: 1 },
    success: function (new_data) {
      var json = JSON.parse(new_data)
      data = {
        labels: hours,
        series: [hours.map(hour => json.find(item => item.hour === hour)?.visits ?? 0)]
      }
      new Chartist.Line('.ct-chart', data, {
        low: 0, height: 400, showArea: true, chartPadding: {
          top: 20,
          right: 0,
          bottom: 25,
          left: 20
        },
        plugins: [
          Chartist.plugins.tooltip({

          }),
          Chartist.plugins.ctAxisTitle({
            axisX: {
              axisTitle: "Hours",
              axisClass: "ct-axis-title",
              offset: {
                x: 0,
                y: 50
              },
              textAnchor: "middle"
            },
            axisY: {
              axisTitle: "No.of visits",
              axisClass: "ct-axis-title",
              offset: {
                x: 0,
                y: -1
              },
              flipTitle: false
            }
          })
        ]
      });
    }
  })
}

function visitPerExhibit() { 
  $.ajax({
    type: 'get',
    url: 'graph.php',
    data: { query: 6 },
    success: function (new_data) {
      var json = JSON.parse(new_data)
      data = {
        labels: json.map(x => x.sensor),
        series: json.map(x => x.sensorCount)
      }
      new Chartist.Bar('.ct-chart', data, {
        distributeSeries: true,
        chartPadding: {
          top: 20,
          right: 0,
          bottom: 25,
          left: 20
        },
        plugins: [
          Chartist.plugins.ctPointLabels({
            textAnchor: 'middle',
            align: 'top',
            labelOffset: { x: 0, y: -2 }
          }),
          Chartist.plugins.ctAxisTitle({
            axisX: {
              axisTitle: "Exhibit/Έκθεμα",
              axisClass: "ct-axis-title",
              offset: {
                x: 0,
                y: 50
              },
              textAnchor: "middle"
            },
            axisY: {
              axisTitle: "No. visits",
              axisClass: "ct-axis-title",
              offset: {
                x: 0,
                y: -1
              },
              flipTitle: false
            }
          })
        ]
      });
    }
  })
}

function timePerExhibit() { 
  $.ajax({
    type: 'get',
    url: 'graph.php',
    data: { query: 7 },
    success: function (new_data) {
      var json = JSON.parse(new_data)
      data = {
        labels: json.map(x => 'Έκθεμα ' + x.exhibit_no),
        series: [json.map(x => parseFloat(x.avg_time).toFixed(2)),
        json.map(x => parseFloat(x.max_time).toFixed(2)),
        json.map(x => parseFloat(x.min_time).toFixed(2)),
        json.map(x => parseFloat(x.sum).toFixed(2))
        ]
      }
      new Chartist.Bar('.ct-chart-bar', data, {
        chartPadding: {
          top: 20,
          right: 0,
          bottom: 25,
          left: 20
        },
        plugins: [
          Chartist.plugins.ctAxisTitle({
            axisX: {
              axisTitle: "Exhibit/Έκθεμα",
              axisClass: "ct-axis-title",
              offset: {
                x: 0,
                y: 50
              },
              textAnchor: "middle"
            },
            axisY: {
              axisTitle: "Time/ Χρόνος",
              axisClass: "ct-axis-title",
              offset: {
                x: 0,
                y: -1
              },
              flipTitle: false
            }
          }),
          Chartist.plugins.legend({
            legendNames: ['Average', 'Maximum', 'Minimum', 'Total'],
          })
        ],
        axisX: {
          position: 'end'
        },
        axisY: {
          position: 'start'
        }
      });
    }
  })
}

function maxAndAvgTimePerExhibit() { 
  $.ajax({
    type: 'get',
    url: 'graph.php',
    data: { query: 8 },
    success: function (new_data) {
      var json = JSON.parse(new_data)
      data = {
        labels: json.map(x => x.sensor_id),
        series: [json.map(x => x.maxTime),
        json.map(x => x.avgTime)]
      }
      new Chartist.Line('.ct-chart', data, {
        lineSmooth: Chartist.Interpolation.simple({
          divisor: 2
        }),
        fullWidth: true,
        chartPadding: {
          right: 20
        },
        low: 0
        , chartPadding: {
          top: 20,
          right: 0,
          bottom: 25,
          left: 20
        },
        plugins: [
          Chartist.plugins.ctAxisTitle({
            axisX: {
              axisTitle: "Exhibit/Έκθεμα",
              axisClass: "ct-axis-title",
              offset: {
                x: 0,
                y: 50
              },
              textAnchor: "middle"
            },
            axisY: {
              axisTitle: "Time/ Χρόνος",
              axisClass: "ct-axis-title",
              offset: {
                x: 0,
                y: -1
              },
              flipTitle: false
            }
          }),
          Chartist.plugins.tooltip({

          }),
          Chartist.plugins.legend({
            legendNames: ['Average', 'Maximum'],
          })
        ]
      });
    }
  })
}

function revisitability() { 
  $.ajax({
    type: 'get',
    url: 'graph.php',
    data: { query: 9 },
    success: function (new_data) {
      var json = JSON.parse(new_data)
      console.log(json)
      data = {
        labels: json.map(x => x.sensor_id),
        series: [json.map(x => x.revisitability),
        json.map(x => x.power_of_attraction)]
      }
      new Chartist.Line('.ct-chart-line', data, {
        fullWidth: true,
        chartPadding: {
          top: 20,
          right: 0,
          bottom: 25,
          left: 20
        }, axisX: {
          onlyinteger: false
        },
        plugins: [
          Chartist.plugins.tooltip({
          }),
          Chartist.plugins.legend({
            legendNames: ['Revisitability', 'Power of attraction']
          }),
          Chartist.plugins.ctAxisTitle({
            axisX: {
              axisTitle: "Sensors",
              axisClass: "ct-axis-title",
              offset: {
                x: 0,
                y: 50
              },
              textAnchor: "middle"
            },
            axisY: {
              axisTitle: "Value",
              axisClass: "ct-axis-title",
              offset: {
                x: 0,
                y: -1
              },
              flipTitle: false
            }
          })
        ]
      });
    }
  })
}

function visitsPerDay() { 
  $.ajax({
    type: 'get',
    url: 'graph.php',
    data: { query: 10 },
    success: function (new_data) {
      var json = JSON.parse(new_data)
      data = {
        labels: json.map(x => x.date),
        series: json.map(x => x.no_of_visits)
      }
      new Chartist.Bar('.ct-chart', data, {
        distributeSeries: true,
        chartPadding: {
          top: 20,
          right: 0,
          bottom: 25,
          left: 20
        },
        plugins: [
          Chartist.plugins.ctPointLabels({
            textAnchor: 'middle',
            align: 'top',
            labelOffset: { x: 0, y: -2 }
          }),
          Chartist.plugins.ctAxisTitle({
            axisX: {
              axisTitle: "Dates/ Ημερομηνίες",
              axisClass: "ct-axis-title",
              offset: {
                x: 0,
                y: 50
              },
              textAnchor: "middle"
            },
            axisY: {
              axisTitle: "No. visits",
              axisClass: "ct-axis-title",
              offset: {
                x: 0,
                y: -1
              },
              flipTitle: false
            }
          })
        ]
      });
    }
  })
}

