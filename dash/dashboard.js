
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
    3: 'Διαδρομή Γ',
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
	const dateFrom = document.getElementById('dateFrom').value;
    const dateTo = document.getElementById('dateTo').value;
	const url = '../php/visitPerHour.php?dateFrom=' + dateFrom + '&dateTo=' + dateTo;
	createChart(url, function (json) {
	  const visits = hours.map(hour => json.find(item => item.visitHour === hour)?.visitsPerHour ?? 0);
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
		  right: 40,
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

  function visitorsPerHour() {
	const dateFrom = document.getElementById('dateFrom').value;
    const dateTo = document.getElementById('dateTo').value;
	const url = '../php/visitorsPerHour.php?dateFrom=' + dateFrom + '&dateTo=' + dateTo;
	createChart(url, function (json) {
	  const visits = hours.map(hour => json.find(item => item.visitHour === hour)?.totalVisitorsPerHour ?? 0);
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
		  right: 40,
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
			  axisTitle: "Αριθμός επισκεπτών",
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
	const dateFrom = document.getElementById('dateFrom').value;
    const dateTo = document.getElementById('dateTo').value;
	const buildingSelect = document.getElementById('buildingSelect').value; // Get the selected building value
    const url = `../php/visitPerExhibit.php?dateFrom=${dateFrom}&dateTo=${dateTo}&building=${buildingSelect}`;
    
	createChart(url, function (json) {
	  const labels = json.map(x => x.roomName);
	  const series = json.map(x => x.totalVisits);
  
	  const data = {
		labels: labels,
		series: series
	  };
  
	  const chartOptions = {
		low: 0,
		height: 400,
		showArea: true,
		distributeSeries: true,
		chartPadding: {
		  top: 20,
		  right: 40,
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

	const dateFrom = document.getElementById('dateFrom').value;
    const dateTo = document.getElementById('dateTo').value;
	const buildingSelect = document.getElementById('buildingSelect').value; // Get the selected building value
    const url = `../php/timePerExhibit.php?dateFrom=${dateFrom}&dateTo=${dateTo}&building=${buildingSelect}`;
    
	createChart(url, function(json) {
	  const labels = json.map(x => x.exhibit_name);
	  const avgTime = json.map(x => parseFloat(x.avg_time).toFixed(2));
	  const maxTime = json.map(x => parseFloat(x.max_time).toFixed(2));
	  const minTime = json.map(x => parseFloat(x.min_time).toFixed(2));
	  const sumTime = json.map(x => parseFloat(x.total_time).toFixed(2));
  
	  const data = {
		labels: labels,
		series: [avgTime, maxTime, minTime, sumTime]
	  };
  
	  const chartOptions = {
		low: 0,
		height: 400,
		showArea: true,
		chartPadding: {
		  top: 20,
		  right: 40,
		  bottom: 25,
		  left: 20
		},
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
			  axisTitle: "Χρόνος Θέασης (secs)",
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
	const dateFrom = document.getElementById('dateFrom').value;
    const dateTo = document.getElementById('dateTo').value;
	const url = `../php/visitorTypes.php?dateFrom=${dateFrom}&dateTo=${dateTo}`;
    
	createChart(url, function (json) {
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
	const dateFrom = document.getElementById('dateFrom').value;
    const dateTo = document.getElementById('dateTo').value;
	const url = `../php/routeIds.php?dateFrom=${dateFrom}&dateTo=${dateTo}`;

	createChart(url, function(json) {
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
			legendNames: json.map(x => routeIdMapping[x.routeId])
		  })
		]
	  };
	  new Chartist.Pie('.ct-chart', data, chartOptions);
	});
  }
  
  
  ///////////////////////////////////////////////////////////////
  
  function revisitability() {

	const dateFrom = document.getElementById('dateFrom').value;
    const dateTo = document.getElementById('dateTo').value;
	const buildingSelect = document.getElementById('buildingSelect').value; // Get the selected building value
    const url = `../php/revisitability.php?dateFrom=${dateFrom}&dateTo=${dateTo}&building=${buildingSelect}`;
	
	createChart(url, function(json) {
	  const labels = json.map(x => x.roomName);
	  const revisitabilityData = json.map(x => x.revisitability);
	  const powerOfAttractionData = json.map(x => x.attractionPower);
  
	  const data = {
		labels: labels,
		series: [revisitabilityData, powerOfAttractionData]
	  };
  
	  const chartOptions = {
		fullWidth: true,
		low: 0,
		height: 400,
		showArea: true,
		chartPadding: {
		  top: 20,
		  right: 50,
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
	const dateFrom = document.getElementById('dateFrom').value;
    const dateTo = document.getElementById('dateTo').value;
	const url = '../php/visitsPerDay.php?dateFrom=' + dateFrom + '&dateTo=' + dateTo;
	createChart(url, function(json) {
	  const labels = json.map(x => x.visitDate);
	  const series = json.map(x => x.visitsPerDay);
  
	  const data = {
		labels: labels,
		series: series
	  };
  
	  const chartOptions = {
		distributeSeries: true,
		low: 0,
		height: 400,
		showArea: true,
		chartPadding: {
		  top: 20,
		  right: 40,
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
	
	if (selectedRadioButton === "attraction") {
		loadDataFromPHP('../php/attractionPower_data.php', 'attraction');
	  } else if (selectedRadioButton === "holding") {
		loadDataFromPHP('../php/holding_data.php', 'holding');
	  } else if (selectedRadioButton === "revisitability") {
		loadDataFromPHP('../php/revisitability_data.php', 'revisitability');
	  } else if (selectedRadioButton === "popularRoutes") {
		loadPopularRoutesFromPHP('../php/popularRoutes.php');
	  }
  }

  function loadDataFromPHP(dataURL, selectedRadioButton) {
	// Make an AJAX request to the PHP file and create circles based on the data
	fetch(dataURL)
	  .then((response) => response.json())
	  .then((data) => {
		createCirclesFromData(data, selectedRadioButton);
	  })
	  .catch((error) => {
		console.error('Error loading data:', error);
	  });
  }

  function loadPopularRoutesFromPHP(dataURL) {
	// Make an AJAX request to the PHP file and create circles based on the data
	fetch(dataURL)
	  .then((response) => response.json())
	  .then((data) => {
		createPopularRoutes(data);
	  })
	  .catch((error) => {
		console.error('Error loading data:', error);
	  });
  }


  
  if (window.location.href.includes('analytics.html')) {
	const roomSelect = document.getElementById('roomSelect');
	
	roomSelect.addEventListener('change', handleDropdownChange);
	roomSelect.addEventListener('change', hidePopover);
	
	showSvg('svgRoom4');
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
		url: 'https://melt.reasonablegraph.org/api/v1/app1/getRatingsPerCellAggregated', // New API endpoint URL
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
  
  function createCirclesFromData(data, selectedRadioButton) {
	const svgContainer = document.getElementById(selectedSVGId);
	const heatmapGTags = svgContainer.querySelectorAll('g[transform]');
		
	// Extract the IDs from heatmapGTags
	const gTagIds = Array.from(heatmapGTags).map((gTag) => gTag.getAttribute('id'));

	// Filter data to only include items with IDs that are in gTagIds
	const filteredData = data.filter((item) => gTagIds.includes(item.cellId));
  
	if (filteredData.length === 0) {
	  // No matching data, handle this case as needed
	  return;
	}
  
	// Find the minimum and maximum values from filteredData
	const values = filteredData.map((item) => item[selectedRadioButton]);
	let minValue = Math.min(...values);
	let maxValue = Math.max(...values);
	if(minValue == maxValue){
		minValue = 0;
	}
	filteredData.forEach((item) => {
		const gTagId = item.cellId;
		const gTag = Array.from(heatmapGTags).find((gTag) => gTag.getAttribute('id') === gTagId);
    	if (gTag) {
				const value = item[selectedRadioButton];
				const path = gTag.querySelector('path');
				const pathBoundingBox = path.getBBox();
			
				const circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
				circle.setAttribute("cx", pathBoundingBox.x + pathBoundingBox.width / 2);
				circle.setAttribute("cy", pathBoundingBox.y + pathBoundingBox.height / 2);
				circle.setAttribute("r", "20");
			
				// Scale the value between 0 and 1
        const scaledValue = (value - minValue) / (maxValue - minValue);

        // Calculate the color based on the scaled value (green to red gradient)
        const hue = 120 - (scaledValue * 120); // Adjust the hue for the gradient
const saturation = 100;
const lightness = 50;
const color = `hsla(${hue}, ${saturation}%, ${lightness}%, 0.5)`;
        circle.setAttribute("fill", color);

				/*const scaledValue = value * 100; // Scale the values to a 0-100 range
				const hue = 120 - (scaledValue * 1.2);
				const saturation = 100;
				const lightness = 50;
			
				circle.setAttribute("fill", `hsla(${hue}, ${saturation}%, ${lightness}%, 0.5)`);
			*/
				gTag.appendChild(circle);
			}

		  });
  }

  function groupReversedPairs(data, svgContainer) {
	const groupedData = [];
  
	data.forEach((row) => {
	  const { firstCellId, secondCellId, totalAppearances } = row;
	  const reversedPairIndex = groupedData.findIndex((groupedRow) =>
		(groupedRow.firstCellId === secondCellId && groupedRow.secondCellId === firstCellId)
	  );
  
	  if (reversedPairIndex !== -1) {
		// Found a reversed pair, update totalAppearances
		groupedData[reversedPairIndex].totalAppearances += Number(totalAppearances);
	  } else {
		// No reversed pair found, add the row to the grouped data if both cell IDs are in the SVG container
		if (
		  svgContainer.getElementById(firstCellId) &&
		  svgContainer.getElementById(secondCellId)
		) {
		  groupedData.push({
			firstCellId,
			secondCellId,
			totalAppearances: Number(totalAppearances),
		  });
		}
	  }
	});
  
	return groupedData;
  }
  
  //////////////////////////////////////////////////////
  
  function createPopularRoutes(data) {
	// Sample list of strings containing room IDs
	if (selectedSVGId) {
		const svgContainer = document.getElementById(selectedSVGId);

		// Track min and max totalAppearances within the container
		const totalAppearancesValues = [];

		// Process the data to group reversed pairs
		const groupedData = groupReversedPairs(data, svgContainer);

		// Find the min and max totalAppearances within the container
		groupedData.forEach((row) => {
			totalAppearancesValues.push(row.totalAppearances);
		  });
	  
		  // Find the min and max totalAppearances within the container
		  const minTotalAppearances = Math.min(...totalAppearancesValues);
		  const maxTotalAppearances = Math.max(...totalAppearancesValues);

			// Iterate over each row in the processed data
			groupedData.forEach((row) => {
				// Extract relevant information from the row
				const { firstCellId, secondCellId, totalAppearances } = row;
		  
				// Find the corresponding 'g' elements
				const start = svgContainer.getElementById(firstCellId);
				const end = svgContainer.getElementById(secondCellId);
		  
				// Check if both start and end elements are found in the svgContainer
				if (start && end) {
				  // Calculate the gradient value based on the min and max totalAppearances within the container
				  const gradientValue = (totalAppearances - minTotalAppearances) / (maxTotalAppearances - minTotalAppearances);
		  
				  // Example color logic: Interpolate color using HSLA
				  const strokeColor = getGradientColor(gradientValue);
		  
				  // Example stroke width logic (you can adjust this based on your preferences)
				  const strokeWidth = getStrokeWidth(totalAppearances);
		  
				  // Create the line element
				  const line = createLineElement(start, end, strokeColor, strokeWidth);
		  
				  // Append the line to the SVG
				  svgContainer.appendChild(line);
				}
		});
	}
  }
  
  
  ////////////////////////////////////
  document.addEventListener('DOMContentLoaded', function() {
    const buildingSelect = document.getElementById('buildingSelect');
    if (buildingSelect) {
        enableSubmitButton();
    }
});

  function enableSubmitButton() {
    const buildingSelect = document.getElementById('buildingSelect');
    const submitButton = document.getElementById('submitButton');

    buildingSelect.addEventListener('change', function() {
        if (buildingSelect.value) {
            submitButton.removeAttribute('disabled');
        } else {
            submitButton.setAttribute('disabled', 'disabled');
        }
    });
}
  
function getGradientColor(gradientValue) {
	// Interpolate color using HSLA
	const hue = 120 - gradientValue * 120; // Adjust the hue range as needed
	const saturation = 100; // Full saturation
	const lightness = 50; // Medium lightness
	const alpha = 1; // Full opacity
  
	return `hsla(${hue}, ${saturation}%, ${lightness}%, ${alpha})`;
  }
	function getStrokeWidth(totalAppearance) {
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
  
  
  
  
  
  
  






