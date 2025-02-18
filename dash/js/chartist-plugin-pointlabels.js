/**
 * Chartist.js plugin to display a data label on top of the points in a line chart.
 *
 */
/* global Chartist */
(function(window, document, Chartist) {
    'use strict';
  
    var defaultOptions = {
      labelClass: 'ct-label',
      labelOffset: {
        x: 0,
        y: -10
      },
      textAnchor: 'middle',
      align: 'center',
      labelInterpolationFnc: Chartist.noop
    };
  
    var labelPositionCalculation = {
      point: function(data) {
        return {
          x: data.x,
          y: data.y
        };
      },
      bar: {
        left: function(data) {
          return {
            x: data.x1,
            y: data.y1
          };
        },
        center: function(data) {
          return {
            x: data.x1 + (data.x2 - data.x1) / 2,
            y: data.y1
          };
        },
        right: function(data) {
          return {
            x: data.x2,
            y: data.y1
          };
        },
        top: function(data) {
          return {
            x: data.x1,
            y: data.y2
          };
        },
        middle: function(data) {
          return {
            x: data.x1,
            y: data.y1 + (data.y2 - data.y1)/2
          };
        }
      }
    };
  
    Chartist.plugins = Chartist.plugins || {};
    Chartist.plugins.ctPointLabels = function(options) {
  
      options = Chartist.extend({}, defaultOptions, options);
  
      function addLabel(position, data) {
        // if x and y exist concat them otherwise output only the existing value
        var value = data.value.x !== undefined && data.value.y ?
          (data.value.x + ', ' + data.value.y) :
          data.value.y || data.value.x;
  
        data.group.elem('text', {
          x: position.x + options.labelOffset.x,
          y: position.y + options.labelOffset.y,
          style: 'text-anchor: ' + options.textAnchor
        }, options.labelClass).text(options.labelInterpolationFnc(value));
      }
  
      return function ctPointLabels(chart) {
        if (chart instanceof Chartist.Line || chart instanceof Chartist.Bar) {
          chart.on('draw', function(data) {
            var positonCalculator = labelPositionCalculation[data.type] && labelPositionCalculation[data.type][options.align] || labelPositionCalculation[data.type];
            if (positonCalculator) {
              addLabel(positonCalculator(data), data);
            }
          });
        }
      };
    };
  
  }(window, document, Chartist));