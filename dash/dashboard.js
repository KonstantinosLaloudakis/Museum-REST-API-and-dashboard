
let data
let config
var date = new Date();
var dateFormat = date.getFullYear() + "-" + ((date.getMonth() + 1).toString().length != 2 ? "0" + (date.getMonth() + 1) : (date.getMonth() + 1)) + "-" + (date.getDate().toString().length != 2 ? "0" + date.getDate() : date.getDate());
var hours = [];
const visitorTypeMapping = {
    1: 'Type A',
    2: 'Type B',
    3: 'Type C',
    4: 'Type D',
    5: 'Type E',
    6: 'Type F',
    7: 'Type G',
    // Add more mappings as needed
};

const routeIdMapping = {
    1: 'Route A',
    2: 'Route B',
    3: 'Route C',
    4: 'Route D',
    5: 'Route E',
    6: 'Route F',
    7: 'Route G',
    // Add more mappings as needed
};

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

function visitorTypes() { 
	createChart('../php/visitorTypes.php', function (json) {
	data = {
		series: json.map(x => x.count)
	}
	new Chartist.Pie('.ct-chart', data, {
		labelInterpolationFnc: function(value) {
			return value;
		  },
  		showLabel: true,
		  width: 300,
		  height: 200,
    	plugins: [
        	Chartist.plugins.legend({
				legendNames: json.map(x => visitorTypeMapping[x.visitorType])
			})
    	]
	  });
	});
}

function routeIds() { 
	createChart('../php/routeIds.php', function (json) {
	data = {
		series: json.map(x => x.count)
	}
	new Chartist.Pie('.ct-chart', data, {
		labelInterpolationFnc: function(value) {
			return value;
		  },
  		showLabel: true,
    	plugins: [
        	Chartist.plugins.legend({
				legendNames: json.map(x => routeIdMapping[x.routeId])
			})
    	]
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

let selectedSVGId = null;
// Function to show the SVG for the selected room
function showSvg(selectedRoom) {
	 // Delete existing circles from the SVG
	 deleteGeneratedShapes();
	 uncheckRadioButtons();
	selectedSVGId = selectedRoom;
	generatePopoverInfo();
	const svgElements = document.querySelectorAll('#svgContainer svg');
	svgElements.forEach(svg => {
	  svg.style.display = svg.id === `${selectedRoom}` ? 'block' : 'none';
	});
  }
  
  // Function to handle dropdown change
  function handleDropdownChange() {
	const selectedRoom = document.getElementById('roomSelect').value;
	showSvg(selectedRoom);
  }
  
  if (window.location.href.includes('analytics.html')) {
  // Add event listener to handle dropdown change
  const roomSelect = document.getElementById('roomSelect');
  roomSelect.addEventListener('change', handleDropdownChange);
  	// Add event listener to the dropdown to hide the popover when changing rooms
	//const roomSelect = document.getElementById('roomSelect');
	roomSelect.addEventListener('change', hidePopover);
  // Initially, show the SVG for the default selected room (e.g., Room 1)
  showSvg('svgRoom1');
  }
// Function to handle radio button selection
function handleRadioSelection() {
	const selectedRadioButton = document.querySelector('input[name="heatmapType"]:checked').value;
	// Delete existing circles from the SVG
	deleteGeneratedShapes(); 
	if(selectedRadioButton == "popularRoutes"){
		createRoutes();
	}
	else{
		// Call the createHeatmap method
		createHeatmap();
	}
}

function generatePopoverInfo(){
	// Get all the <g> tags
	svgContainer = document.getElementById(selectedSVGId);
	
	const gTags = svgContainer.querySelectorAll('g[transform]');
	const popover = document.getElementById('popover');
	
	// Add click event listener to each <g> tag
	gTags.forEach((gTag) => {
			gTag.addEventListener('click', showPopover);
	  });
	}

// Function to delete every circle element in the SVG
function deleteGeneratedShapes() {
	// Get the SVG element
	const svg = document.getElementById('svgContainer');
	const circles = svg.querySelectorAll('circle');
	const lines = svg.querySelectorAll('line');
	circles.forEach(circle => circle.remove());
	lines.forEach(line => line.remove());
  }

  // Function to uncheck any checked radio button
function uncheckRadioButtons() {
	const radioButtons = document.querySelectorAll('input[name="heatmapType"]');
	radioButtons.forEach(radio => radio.checked = false);
  }

  // Add event listeners for radio buttons
const radioButtons = document.querySelectorAll('input[name="heatmapType"]');
radioButtons.forEach(radio => radio.addEventListener('change', handleRadioSelection));


function createHeatmap(){
	svgContainer = document.getElementById(selectedSVGId);

	const heatmapGTags = svgContainer.querySelectorAll('g[transform]');
	heatmapGTags.forEach((gTag) => {
		const value = Math.floor(Math.random() * 100)
		gTag.setAttribute("data-value", value);
		const path = gTag.getElementsByTagName('path')[0];
    	const pathBoundingBox = path.getBBox();
		const circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
		circle.setAttribute("cx", pathBoundingBox.x + pathBoundingBox.width / 2);
		circle.setAttribute("cy", pathBoundingBox.y + pathBoundingBox.height / 2);
		circle.setAttribute("r", "20");
		//circle.setAttribute("fill", `rgb(${value * 2.55}, ${255 - value * 2.55}, 0, 0.5)`);
		// Calculate the hue value based on the value (from green to red)
		const hue = 120 - (value * 1.2);

		// Set the saturation and lightness to a constant value
		const saturation = 100;
		const lightness = 50;
	
		circle.setAttribute("fill", `hsla(${hue}, ${saturation}%, ${lightness}%, 0.5)`);
	
		gTag.appendChild(circle);
		
	});

}
function createRoutes(){
	// Sample list of strings containing room IDs
	const stringList = [
		'Room2, Room3, Room4',
		'Room1, Room2, Room3',
		'Room1, Room2, Room3',
		'Room1, Room2, Room3',
		'Room1, Room7, Room2',
		'Room3, Room4, Room5',
		'Room5, Room6, Room9',
		'Room8, Room9, Room6'
	];
	if(selectedSVGId){
		svgContainer = document.getElementById(selectedSVGId);

		// Track the number of times a line is repeated between two room IDs
		const lineCounts = {};
	
		// Iterate over each string
		stringList.forEach((string) => {
			// Extract the room IDs from the string
			const roomIds = string.split(',').map((roomId) => roomId.trim());
	
			// Find the corresponding 'g' elements
			const gElements = roomIds.map((roomId) => svgContainer.getElementById(roomId));
	
			// Create a line connecting the 'g' elements
			for (let i = 0; i < gElements.length - 1; i++) {
				const start = gElements[i];
				const end = gElements[i + 1];
	
				// Generate a unique identifier for the line based on the room IDs
				const lineId = `${start.id}-${end.id}`;
	
				// Increment the line count or initialize it to 1
				lineCounts[lineId] = lineCounts[lineId] ? lineCounts[lineId] + 1 : 1;
	
				// Calculate the gradient value based on the line count
				const gradientValue = 1 - 1 / (lineCounts[lineId] + 1);
	
				// Calculate the stroke color based on the gradient value
				const strokeColor = getStrokeColor(lineCounts[lineId]);
	
				// Calculate the stroke width based on the line count
				const strokeWidth = getStrokeWidth(lineCounts[lineId]); // Adjust the thickness as desired
	
				// Create the line element
				const line = createLineElement(start, end, strokeColor, strokeWidth);
	
				// Append the line to the SVG
				svgContainer.appendChild(line);
			}
		});
	}
}

function getStrokeColor(lineCount) {
	const green = 120;
	const red = 0;
  
	const hue = green - (lineCount - 1) * (green / 9); // Line count ranges from 1 to 10
	const saturation = 100;
	const lightness = 50;
  
	return `hsla(${hue}, ${saturation}%, ${lightness}%, 1)`;
  }
  function getStrokeWidth(lineCount) {
	//return 2 + 0.3 * lineCount; // Adjust the thickness as desired
	return 2; // Adjust the thickness as desired
  }
  
  function createLineElement(start, end, strokeColor, strokeWidth) {
	const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
	line.setAttribute('x1', parseFloat(start.getAttribute('transform').split(',')[0].slice(10)));
	line.setAttribute('y1', parseFloat(start.getAttribute('transform').split(',')[1].slice(0, -1)));
	line.setAttribute('x2', parseFloat(end.getAttribute('transform').split(',')[0].slice(10)));
	line.setAttribute('y2', parseFloat(end.getAttribute('transform').split(',')[1].slice(0, -1)));
	line.setAttribute('stroke', strokeColor);
	line.setAttribute('stroke-width', strokeWidth.toString()); // Convert strokeWidth to string
	return line;
  }






