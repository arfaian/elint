(function() {
  var width = 200,
      height = 200,
      radius = Math.min(width, height) / 2;

  var color = d3.scale.ordinal()
      .range(["#39DBAC", "#F8591A", "#0D8FDB", "#3a5a97", "#434A52"]);

  var arc = d3.svg.arc()
      .outerRadius(radius - 10)
      .innerRadius(radius - 18);

  var pie = d3.layout.pie()
      .sort(null)
      .value(function(d) { return d.amount; });

  var svg = d3.select("#chart-categories")
      .attr("width", width)
      .attr("height", height)
    .append("g")
      .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

  var chartSvg = $('#chart-categories');

  $(window).on("resize", function() {
    var targetWidth = chartSvg.parent().width();
    chartSvg.attr("width", Math.min(200, targetWidth));
    chartSvg.attr("height", Math.min(200, targetWidth));
  });

  var pattern = /[\d\.\d]+/g;

  drawCategoryChart = function(data) {

    data = _.groupBy(data, function(t) {
      var cat = "uncategorized";
      if (t.categories.length) {
        cat = t.categories[0].name
      }
      return cat;
    });

    var sums = [];
    for (k in data) {
      var arr = data[k];
      for (var i = 0; i < arr.length; i++) {
        var t = arr[i];
        var el = _.find(sums, function(s) { return s.category === k; })
        if (el !== undefined) {
          el.amount += parseFloat(t.amount.match(pattern)) * 100;
        } else {
          sums.push({
            category: k,
            amount: parseFloat(t.amount.match(pattern)) * 100
          });
        }
      }
    }

    data = sums;

    var g = svg.selectAll(".arc")
        .data(pie(data))
      .enter().append("g")
        .attr("class", "arc");

    g.append("path")
        .each(function() { this._current = {startAngle: 0, endAngle: 0}; })
        .style("fill", function(d) { return color(d.data.category); })
        .transition()
        .duration(1200)
        .attrTween("d", function(d) {
          var interpolate = d3.interpolate(this._current, d);
          this._current = interpolate(0);
          return function(t) {
            return arc(interpolate(t));
          };
        });

    function animateText(el, val) {
      $({value: 0}).animate({value: val / 100}, {
        duration: 1100,
        easing:'swing',
        step: function() {
          el.text(this.value.toFixed(2));
        },
        complete: function() {
          el.text(this.value.toFixed(2));
        }
      });
    }

  }
})();
