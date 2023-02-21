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

function createChart(url, createChartFunc) {
	$.ajax({
	  type: 'get',
	  url: url,
	  data: data,
	  success: function (new_data) {
		var json = JSON.parse(new_data)
		createChartFunc(json);
	  }
	});
}

function generateChart(type, domElement, data, options){
	if(type == 'line'){
		new Chartist.Line(domElement, data, options);
	}
	else if(type == 'bar'){
		new Chartist.Bar(domElement, data, options);

	}
}

function visitPerHour() {
	createChart('../php/visitPerHour.php', function (json) {
	  data = {
		labels: hours,
		series: [hours.map(hour => json.find(item => item.hour === hour)?.visits ?? 0)]
	  }
	  generateChart('line', '.ct-chart', data, {
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
	});
}

function visitPerExhibit() { 
	createChart('../php/visitPerExhibit.php', function (json) {
	  data = {
		labels: json.map(x => x.sensor),
		series: json.map(x => x.sensorCount)
	  }
	  generateChart('bar', '.ct-chart', data, {
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
	});
}

  function timePerExhibit() { 
	createChart('../php/timePerExhibit.php', function (json) {
	  data = {
		labels: json.map(x => 'Έκθεμα ' + x.exhibit_no),
		series: [json.map(x => parseFloat(x.avg_time).toFixed(2)),
		json.map(x => parseFloat(x.max_time).toFixed(2)),
		json.map(x => parseFloat(x.min_time).toFixed(2)),
		json.map(x => parseFloat(x.sum).toFixed(2))
        ]
	}
	generateChart('bar', '.ct-chart-bar', data, {
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
	});
}

function maxAndAvgTimePerExhibit() { 
	createChart('../php/maxAndAvgTimePerExhibit.php', function (json) {
		data = {
			labels: json.map(x => x.sensor_id),
			series: [json.map(x => x.maxTime),
			json.map(x => x.avgTime)]
		  }
	generateChart('line', '.ct-chart', data, {
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
	});
}

function revisitability() { 
	createChart('../php/revisitability.php', function (json) {
		data = {
			labels: json.map(x => x.sensor_id),
			series: [json.map(x => x.revisitability),
			json.map(x => x.power_of_attraction)]
		}
		generateChart('line', '.ct-chart-line', data, {
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
	});
}

function visitsPerDay() { 
	createChart('../php/visitsPerDay.php',  function (json) {
		data = {
			labels: json.map(x => x.date),
			series: json.map(x => x.no_of_visits)
		  }
		generateChart('bar', '.ct-chart', data, {
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
	});
}


