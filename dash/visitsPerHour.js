
let data
let config

/*window.onload = function () {
  this.init();
  this.init2();
  this.init3();
  this.init4();
}*/
function visitPerHour () {
  $.ajax({
    type: 'get',
    url: 'graph.php',
    data: { query: 1 },
    success: function (new_data) {
      var json = JSON.parse(new_data)
      console.log(json)
      //console.log(json.map(x => x.total_time))
      data = {
        labels: json.map(x => x.hour),
        series: [json.map(x => x.visits)]
      }

      
	  new Chartist.Line('.ct-chart', data, {low: 0, showArea: true});
      //var myChart = new Chart(document.getElementById('myChart'), config)
      //var myChart1 = new Chart(document.getElementById('myChart1'), config1)

      //remaining of your chart code goes here, add this json to data
    }
  })
}

function init2 () {
  $.ajax({
    type: 'get',
    url: 'graph.php',
    data: { query: 2 },
    success: function (new_data) {
      var json = JSON.parse(new_data)
      console.log(json)
      console.log(json.map(x => new Date(x.time_out) - new Date(x.time_in)))
      data = {
        labels: json.map(x => 'Exhibit ' + x.sensor_id),
        datasets: [
          {
            label: 'sum minutes',
            data: json.map(x => x.sum_time),
            backgroundColor: [
              '#4dc9f6',
              '#f67019',
              '#f53794',
              '#537bc4',
              '#acc236',
              '#166a8f',
              '#00a950',
              '#58595b',
              '#8549ba',
              '#009933',
              '#cc6600',
              '#ffffcc',
              '#993333',
              '#003366',
              '#cc33ff'
            ]
          }
        ]
      }

      config = {
        type: 'bar',
        data: data,
        options: {
          responsive: true,
          plugins: {
            datalabels: {
              display: true,
              align: 'bottom',
              backgroundColor: '#ccc',
              borderRadius: 3,
              font: {
                size: 18
              }
            },
            legend: {
              position: 'top'
            },
            title: {
              display: true,
              text: 'Sum of time visited in minutes'
            }
          }
        }
      }

      Chart.register(ChartDataLabels)
      Chart.defaults.set('plugins.datalabels', {
        color: '#FE777B'
      })
      var myChart2 = new Chart(document.getElementById('myChart2'), config)

      //remaining of your chart code goes here, add this json to data
    }
  })
}

function init3 () {
  $.ajax({
    type: 'get',
    url: 'graph.php',
    data: { query: 3 },
    success: function (new_data) {
      var json = JSON.parse(new_data)
      data = {
        labels: json.map(x => 'Exhibit ' + x.exhibit_no),
        datasets: [
          {
            label: 'sum minutes',
            data: json.map(x => x.avg_time),
            backgroundColor: [
              '#4dc9f6',
              '#f67019',
              '#f53794',
              '#537bc4',
              '#acc236',
              '#166a8f',
              '#00a950',
              '#58595b',
              '#8549ba',
              '#009933',
              '#cc6600',
              '#ffffcc',
              '#993333',
              '#003366',
              '#cc33ff'
            ]
          }
        ]
      }

      config = {
        type: 'radar',
        data: data,
        options: {
          responsive: true,
          scale: {
            min: 0
          },
          plugins: {
            datalabels: {
              display: true,
              align: 'bottom',
              backgroundColor: '#ccc',
              borderRadius: 3,
              font: {
                size: 18
              }
            },
            legend: {
              position: 'top'
            },
            title: {
              display: true,
              text: 'Avg time visited in minutes'
            }
          }
        }
      }

      Chart.register(ChartDataLabels)
      Chart.defaults.set('plugins.datalabels', {
        color: '#FE777B'
      })
      var myChart3 = new Chart(document.getElementById('myChart3'), config)

      //remaining of your chart code goes here, add this json to data
    }
  })
}
function init4 () {
  $.ajax({
    type: 'get',
    url: 'graph.php',
    data: { query: 4 },
    success: function (new_data) {
      var json = JSON.parse(new_data)
      console.log(json)
      console.log(chartColors)
      data = {
        labels: json.map(x => 'Exhibit ' + x.sensor_id),
        datasets: [
          {
            label: 'Avg time',
            data: json.map(x => Number(x.time_avg).toFixed(1)),
            borderColor: chartColors.red,
            backgroundColor: Samples.utils.transparentize(255, 99, 132, 0.5)
          },
          {
            label: 'Max time',
            data: json.map(x => Number(x.time_max).toFixed(1)),
            borderColor: chartColors.green,
            backgroundColor: Samples.utils.transparentize(75, 192, 192, 0.5)
          },

          {
            label: 'Min time',
            data: json.map(x => Number(x.time_min).toFixed(1)),
            borderColor: chartColors.black,
            backgroundColor: Samples.utils.transparentize(153, 102, 255, 0.5)
          }
        ]
      }
      console.log(data)

      const config = {
        type: 'line',
        data: data,
        options: {
          responsive: true,
          plugins: {
            legend: {
              position: 'top'
            },
            title: {
              display: true,
              text: 'Time visited per exhibit'
            }
          }
        }
      }

      Chart.register(ChartDataLabels)
      Chart.defaults.set('plugins.datalabels', {
        color: '#FE777B'
      })
      var myChart4 = new Chart(document.getElementById('myChart4'), config)

      //remaining of your chart code goes here, add this json to data
    }
  })
}

function init5(){

  $.ajax({
    type: 'get',
    url: 'graph.php',
    data: { query: 5 },
    success: function (new_data) {
      var json = JSON.parse(new_data)
      console.log(json)
      //console.log(json.map(x => x.total_time))
      data = {
        labels: json.map(x => x.hour),
        series: [json.map(x => x.visits)]
      }



      new Chartist.Pie('.ct-chart', data, {low: 0, showArea: true});
    }
    

    
  })

}




function visitPerExhibit(){ // visit per exhibit

  $.ajax({
    type: 'get',
    url: 'graph.php',
    data: { query: 6 },
    success: function (new_data) {
      var json = JSON.parse(new_data)
      console.log(json)
      //console.log(json.map(x => x.total_time))
      data = {
        labels: json.map(x => x.sensor),
        series: json.map(x => x.sensorCount)
      }



      new Chartist.Bar('.ct-chart', data, {distributeSeries: true});
    }
    

    
  })

}

function timePerExhibit(){ // visit per exhibit

  $.ajax({
    type: 'get',
    url: 'graph.php',
    data: { query: 7 },
    success: function (new_data) {
      var json = JSON.parse(new_data)
      console.log(json)
      //console.log(json.map(x => x.total_time))
      data = {
        labels: json.map(x => 'Έκθεμα ' + x.exhibit_no),
        series: [json.map(x => parseFloat(x.avg_time).toFixed(2)),
                  json.map(x=>parseFloat(x.max_time).toFixed(2)),
                  json.map(x=>parseFloat(x.min_time).toFixed(2)),
                  json.map(x=>parseFloat(x.sum).toFixed(2))
      ]
      }



      new Chartist.Bar('.ct-chart', data, {
        plugins: [
          Chartist.plugins.ctPointLabels({
            textAnchor: 'middle',
            align: 'top',
            labelOffset: {x:0, y:-2}
          }),
          Chartist.plugins.tooltip({

          })
        ],
       axisX: {
        position: 'start'
      },
    axisY: {
      position: 'end'
    }
  });
    }
    

    
  })

}


function maxAndAvgTimePerExhibit(){ // visit per exhibit

  $.ajax({
    type: 'get',
    url: 'graph.php',
    data: { query: 8 },
    success: function (new_data) {
      var json = JSON.parse(new_data)
      console.log(json)
      //console.log(json.map(x => x.total_time))
      data = {
        labels: json.map(x => x.sensor_id),
        series: [json.map(x => x.maxTime),
                json.map(x => x.avgTime)]
      }



      new Chartist.Line('.ct-chart', data, {lineSmooth: Chartist.Interpolation.simple({
        divisor: 2
      }),
      fullWidth: true,
      chartPadding: {
        right: 20
      },
      low: 0
    });
    }
    

    
  })

}

function revisitability(){ // visit per exhibit

  $.ajax({
    type: 'get',
    url: 'graph.php',
    data: { query: 9  },
    success: function (new_data) {
      var json = JSON.parse(new_data)
      console.log(json)
      //console.log(json.map(x => x.total_time))
      data = {
        labels: json.map(x => x.sensor_id),
        series: [json.map(x => x.revisitability),
                  json.map(x => x.power_of_attraction)]
      }



      new Chartist.Line('.ct-chart', data, { fullWidth: true,
        chartPadding: {
          right: 40
        },axisX:{
          onlyinteger:false
        }});
    }
    

    
  })

}

function visitsPerDay(){ // visit per exhibit

	$.ajax({
	  type: 'get',
	  url: 'graph.php',
	  data: { query: 10  },
	  success: function (new_data) {
		var json = JSON.parse(new_data)
		console.log(json)
		//console.log(json.map(x => x.total_time))
		data = {
		  labels: json.map(x => x.date),
		  series: json.map(x => x.no_of_visits)
		}
  
  
  
		new Chartist.Bar('.ct-chart', data, {distributeSeries: true});
	  }
	  
  
	  
	})
  
  }




//setInterval(init, 5000);
