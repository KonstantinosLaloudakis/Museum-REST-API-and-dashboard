
let data
let config
var date = new Date();
var dateFormat = date.getFullYear() + "-" + ((date.getMonth() + 1).toString().length != 2 ? "0" + (date.getMonth() + 1) : (date.getMonth() + 1)) + "-" + (date.getDate().toString().length != 2 ? "0" + date.getDate() : date.getDate());
var hours = [];
const visitorTypeMapping = {
    1: 'Ενήλικος (EL)',
    2: 'Ανήλικος (EL)',
    3: 'Εμπειρογνώμονας (EL)',
    4: 'Ενήλικος (ΕN)',
    5: 'Ενήλικος (ΕN)',
    6: 'Εμπειρογνώμονας (EN)',
    // Add more mappings as needed
};

const routeIdMapping = {
    1: 'Διαδρομή Α',
    2: 'Διαδρομή Β',
    3: 'Διαδροδρομή Γ',
   // 4: 'Route D',
    //5: 'Route E',
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
	  const visits = hours.map(hour => json.find(item => item.hour === hour)?.visits ?? 0);
	  const data = {
		labels: hours,
		series: [visits]
	  };
	  const chartOptions = {
		low: 0,
		height: 400,
		showArea: true,
		chartPadding: {
		  top: 20,
		  right: 0,
		  bottom: 25,
		  left: 20
		},
		plugins: [
		  Chartist.plugins.tooltip(),
		  Chartist.plugins.ctAxisTitle({
			axisX: {
			  axisTitle: "Ώρες",
			  axisClass: "ct-axis-title",
			  offset: {
				x: 0,
				y: 50
			  },
			  textAnchor: "middle"
			},
			axisY: {
			  axisTitle: "Αριθμός επισκέψεων",
			  axisClass: "ct-axis-title",
			  offset: {
				x: 0,
				y: -1
			  },
			  flipTitle: false
			}
		  })
		]
	  };
	  generateChart('line', '.ct-chart', data, chartOptions);
	});
  }
  
  //////////////////////////////////////////////////
  
  function visitPerExhibit() {
	createChart('../php/visitPerExhibit.php', function (json) {
	  const labels = json.map(x => x.sensor);
	  const series = json.map(x => x.sensorCount);
  
	  const data = {
		labels: labels,
		series: series
	  };
  
	  const chartOptions = {
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
			  axisTitle: "Έκθεμα",
			  axisClass: "ct-axis-title",
			  offset: {
				x: 0,
				y: 50
			  },
			  textAnchor: "middle"
			},
			axisY: {
			  axisTitle: "Αριθμός επισκέψεων",
			  axisClass: "ct-axis-title",
			  offset: {
				x: 0,
				y: -1
			  },
			  flipTitle: false
			}
		  })
		]
	  };
  
	  generateChart('bar', '.ct-chart', data, chartOptions);
	});
  }
  
  
  ////////////////////////////////////////////////
  
  function timePerExhibit() {
	createChart('../php/timePerExhibit.php', function(json) {
	  const labels = json.map(x => 'Έκθεμα ' + x.exhibit_no);
	  const avgTime = json.map(x => parseFloat(x.avg_time).toFixed(2));
	  const maxTime = json.map(x => parseFloat(x.max_time).toFixed(2));
	  const minTime = json.map(x => parseFloat(x.min_time).toFixed(2));
	  const sumTime = json.map(x => parseFloat(x.sum).toFixed(2));
  
	  const data = {
		labels: labels,
		series: [avgTime, maxTime, minTime, sumTime]
	  };
  
	  const chartOptions = {
		chartPadding: {
		  top: 20,
		  right: 0,
		  bottom: 25,
		  left: 20
		},
		plugins: [
		  Chartist.plugins.ctAxisTitle({
			axisX: {
			  axisTitle: "Εκθεμα",
			  axisClass: "ct-axis-title",
			  offset: {
				x: 0,
				y: 50
			  },
			  textAnchor: "middle"
			},
			axisY: {
			  axisTitle: "Χρόνος Έκθεσης",
			  axisClass: "ct-axis-title",
			  offset: {
				x: 0,
				y: -1
			  },
			  flipTitle: false
			}
		  }),
		  Chartist.plugins.legend({
			legendNames: ['Μέσος', 'Μέγιστος', 'Ελάχιστος', 'Συνολικός'],
		  })
		],
		axisX: {
		  position: 'end'
		},
		axisY: {
		  position: 'start'
		}
	  };
  
	  generateChart('bar', '.ct-chart-bar', data, chartOptions);
	});
  }
  
  
  ///////////////////////////////////////////////////////
  
  function visitorTypes() {
	const chartContainer = document.querySelector('.ct-chart'); // Get the chart container element
  
	createChart('../php/visitorTypes.php', function (json) {
	  const data = {
		series: json.map(x => x.count)
	  };
  
	  const chartOptions = {
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
	  };
  
	  // Function to set the chart container height
	  function setChartContainerHeight(height) {
		chartContainer.style.height = height + 'px';
	  }
  
	  // Call the function with the initial height and adjust as needed
	  setChartContainerHeight(500); // Set initial height
  
	  // Example: Adjust height on window resize
	  window.addEventListener('resize', function () {
		if (window.innerWidth <= 768) {
		  setChartContainerHeight(150); // Adjusted height for smaller screens
		} else {
		  setChartContainerHeight(200); // Reset to default height
		}
	  });
  
	  new Chartist.Pie('.ct-chart', data, chartOptions);
	});
  }
  
  
  
  /////////////////////////////////////////////////////////
  
  function routeIds() {
	createChart('../php/routeIds.php', function(json) {
	  const data = {
		series: json.map(x => x.count)
	  };
	  const chartOptions = {
		labelInterpolationFnc: function(value) {
		  return value;
		},
		showLabel: true,
		plugins: [
		  Chartist.plugins.legend({
			legendNames: json.map(x => routeIdMapping[x.routeId])
		  })
		]
	  };
	  new Chartist.Pie('.ct-chart', data, chartOptions);
	});
  }
  
  
  ///////////////////////////////////////////////////////////////
  
  function maxAndAvgTimePerExhibit() {
	createChart('../php/maxAndAvgTimePerExhibit.php', function(json) {
	  const labels = json.map(x => x.sensor_id);
	  const maxTime = json.map(x => x.maxTime);
	  const avgTime = json.map(x => x.avgTime);
  
	  const data = {
		labels: labels,
		series: [maxTime, avgTime]
	  };
  
	  const chartOptions = {
		lineSmooth: Chartist.Interpolation.simple({
		  divisor: 2
		}),
		fullWidth: true,
		chartPadding: {
		  right: 20,
		  top: 20,
		  bottom: 25,
		  left: 20
		},
		low: 0,
		plugins: [
		  Chartist.plugins.ctAxisTitle({
			axisX: {
			  axisTitle: "Έκθεμα",
			  axisClass: "ct-axis-title",
			  offset: {
				x: 0,
				y: 50
			  },
			  textAnchor: "middle"
			},
			axisY: {
			  axisTitle: "Χρόνος",
			  axisClass: "ct-axis-title",
			  offset: {
				x: 0,
				y: -1
			  },
			  flipTitle: false
			}
		  }),
		  Chartist.plugins.tooltip(),
		  Chartist.plugins.legend({
			legendNames: ['Μέσος', 'Μέγιστος']
		  })
		]
	  };
  
	  generateChart('line', '.ct-chart', data, chartOptions);
	});
  }
  
  
  //////////////////////////////////////////////////////////
  
  function revisitability() {
	createChart('../php/revisitability.php', function(json) {
	  const labels = json.map(x => x.sensor_id);
	  const revisitabilityData = json.map(x => x.revisitability);
	  const powerOfAttractionData = json.map(x => x.power_of_attraction);
  
	  const data = {
		labels: labels,
		series: [revisitabilityData, powerOfAttractionData]
	  };
  
	  const chartOptions = {
		fullWidth: true,
		chartPadding: {
		  top: 20,
		  right: 0,
		  bottom: 25,
		  left: 20
		},
		axisX: {
		  onlyInteger: false
		},
		plugins: [
		  Chartist.plugins.tooltip(),
		  Chartist.plugins.legend({
			legendNames: ['Επανεπισκεψιμότητα', 'Δύναμη Έλξης']
		  }),
		  Chartist.plugins.ctAxisTitle({
			axisX: {
			  axisTitle: "Εκθέματα",
			  axisClass: "ct-axis-title",
			  offset: {
				x: 0,
				y: 50
			  },
			  textAnchor: "middle"
			},
			axisY: {
			  axisTitle: "Τιμή",
			  axisClass: "ct-axis-title",
			  offset: {
				x: 0,
				y: -1
			  },
			  flipTitle: false
			}
		  })
		]
	  };
  
	  generateChart('line', '.ct-chart-line', data, chartOptions);
	});
  }
  
  
  //////////////////////////////////////////////////////////////////////
  
  
  function visitsPerDay() {
	createChart('../php/visitsPerDay.php', function(json) {
	  const labels = json.map(x => x.date);
	  const series = json.map(x => x.no_of_visits);
  
	  const data = {
		labels: labels,
		series: series
	  };
  
	  const chartOptions = {
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
			  axisTitle: "Ημερομηνίες",
			  axisClass: "ct-axis-title",
			  offset: {
				x: 0,
				y: 50
			  },
			  textAnchor: "middle"
			},
			axisY: {
			  axisTitle: "Αριθμός επισκέψεων",
			  axisClass: "ct-axis-title",
			  offset: {
				x: 0,
				y: -1
			  },
			  flipTitle: false
			}
		  })
		]
	  };
  
	  generateChart('bar', '.ct-chart', data, chartOptions);
	});
  }
  
  
  //////////////////////////////////////////////////////////////////////////
  
  let selectedSVGId = null;
  
  // Function to show the SVG for the selected room
  function showSvg(selectedRoom) {
	deleteGeneratedShapes();
	uncheckRadioButtons();
	selectedSVGId = selectedRoom;
	generatePopoverInfo();
	
	const svgElements = document.querySelectorAll('#svgContainer svg');
	svgElements.forEach(svg => {
	  svg.style.display = svg.id === selectedRoom ? 'block' : 'none';
	});
  }
  
  // Function to handle dropdown change
  function handleDropdownChange() {
	const selectedRoom = document.getElementById('roomSelect').value;
	showSvg(selectedRoom);
  }
  
  // Function to handle radio button selection
  function handleRadioSelection() {
	const selectedRadioButton = document.querySelector('input[name="heatmapType"]:checked').value;
	
	deleteGeneratedShapes();
	
	if (selectedRadioButton === "popularRoutes") {
	  createRoutes();
	} else {
	  createHeatmap();
	}
  }
  
  if (window.location.href.includes('analytics.html')) {
	const roomSelect = document.getElementById('roomSelect');
	
	roomSelect.addEventListener('change', handleDropdownChange);
	roomSelect.addEventListener('change', hidePopover);
	
	showSvg('svgRoom1');
  }
  
  
  
  //////////////////////////////////////////////////////////////////////
  
  function generatePopoverInfo() {
	// Get all the <g> tags
	const svgContainer = document.getElementById(selectedSVGId);
	const gTags = svgContainer.querySelectorAll('g[transform]');
	const popover = document.getElementById('popover');
	getRatings(function (ratings) {
        if (ratings == null) {
            return;
        }
        // Add click event listener to each <g> tag
        gTags.forEach((gTag) => {
            gTag.addEventListener('click', () => showPopover(gTag, ratings));
        });
    });
  }

   function getRatings(callback){
	$.ajax({
		url: '../php/getCellRatings.php', // URL to the server-side script
		method: 'GET',
		dataType: 'json',
		success: function(data) {
			 // Process the data received from the server
			 callback(data); // Pass the data to the callback function
		},
		error: function(error) {
			console.error('Error: ', error);
			callback(null); // Pass null to the callback function in case of an error
		}
	});
  }
  
  function deleteGeneratedShapes() {
	// Get the SVG element
	const svg = document.getElementById('svgContainer');
	const circles = svg.querySelectorAll('circle');
	const lines = svg.querySelectorAll('line');
  
	// Remove every circle element in the SVG
	circles.forEach(circle => circle.remove());
  
	// Remove every line element in the SVG
	lines.forEach(line => line.remove());
  }
  
  function uncheckRadioButtons() {
	const radioButtons = document.querySelectorAll('input[name="heatmapType"]');
  
	// Uncheck any checked radio button
	radioButtons.forEach(radio => radio.checked = false);
  }
  
  // Add event listeners for radio buttons
  const radioButtons = document.querySelectorAll('input[name="heatmapType"]');
  radioButtons.forEach(radio => radio.addEventListener('change', handleRadioSelection));
  
  ///////////////////////////////////////////////////////////////////////////////////
  
  function createHeatmap() {
	const svgContainer = document.getElementById(selectedSVGId);
	const heatmapGTags = svgContainer.querySelectorAll('g[transform]');
  
	heatmapGTags.forEach((gTag) => {
	  const value = Math.floor(Math.random() * 100);
	  gTag.setAttribute("data-value", value);
  
	  const path = gTag.querySelector('path');
	  const pathBoundingBox = path.getBBox();
  
	  const circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
	  circle.setAttribute("cx", pathBoundingBox.x + pathBoundingBox.width / 2);
	  circle.setAttribute("cy", pathBoundingBox.y + pathBoundingBox.height / 2);
	  circle.setAttribute("r", "20");
  
	  const hue = 120 - (value * 1.2);
	  const saturation = 100;
	  const lightness = 50;
  
	  circle.setAttribute("fill", `hsla(${hue}, ${saturation}%, ${lightness}%, 0.5)`);
  
	  gTag.appendChild(circle);
	});
  }
  
  //////////////////////////////////////////////////////
  
  function createRoutes() {
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
  
	if (selectedSVGId) {
	  const svgContainer = document.getElementById(selectedSVGId);
  
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
  
  
  ////////////////////////////////////
  
  
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
  
  
  
  
  
  
  






