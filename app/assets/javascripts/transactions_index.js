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

  var svg = d3.select("#chart-saved-spent")
      .attr("width", width)
      .attr("height", height)
    .append("g")
      .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

  var chartSvg = $('#chart-saved-spent');

  $(window).on("resize", function() {
    var targetWidth = chartSvg.parent().width();
    chartSvg.attr("width", Math.min(200, targetWidth));
    chartSvg.attr("height", Math.min(200, targetWidth));
  });

  var pattern = /[\d\.\d]+/g;

  d3.json(window.location.pathname + ".json", function(error, data) {

    drawCategoryChart(data);

    data.forEach(function(d) {
      d.amount = parseFloat(d.amount.match(pattern)) * 100;
    });

    var newData = _.groupBy(data, function(d) { return d.transaction_type });

    var newArray = [];
    _.each(newData, function(v, k) {
      var obj = {
        transaction_type: k + 's',
        amount: _.reduce(v, function(sum, d) { return sum + d.amount }, 0)
      };
      newArray.push(obj);
    });

    data.length = 0;
    var debits = _.findWhere(newArray, { transaction_type: 'debits' })
      || { transaction_type: 'debits', amount: 0 };
    var credits = _.findWhere(newArray, { transaction_type: 'credits' })
      || { transaction_type: 'credits', amount: 0 };
    var saved = credits.amount - debits.amount;

    if (credits.amount === 0) {
      saved = (0.0).toFixed(2);
    }

    var chartSaved = saved <= 0 ? 0 : saved;
    data.push({ transaction_type: 'saved', amount: chartSaved });
    data.push({ transaction_type: 'spent', amount: debits.amount });

    var g = svg.selectAll(".arc")
        .data(pie(data))
      .enter().append("g")
        .attr("class", "arc");

    g.append("path")
        .each(function() { this._current = {startAngle: 0, endAngle: 0}; })
        .style("fill", function(d) { return color(d.data.transaction_type); })
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

    var savedTextBox = svg.append('g')
      .attr("transform", "translate(7.5, -12)");

    savedTextBox.append("circle")
        .attr('r', 6)
        .attr("transform", "translate(-7,0)")
        .style("fill",  color('saved'));

    savedTextBox.append('text')
      .attr("dy", ".35em")
      .attr("transform", "translate(-16,0)")
      .style("text-anchor", "end")
      .text('saved');

    var svt = savedTextBox.append('text')
      .attr("dy", ".35em")
      .attr("transform", "translate(2,0)")
      .style("text-anchor", "start");

    var spentTextBox = svg.append('g')
      .attr("transform", "translate(7.5, 12)")

    spentTextBox.append("circle")
        .attr('r', 6)
        .attr("transform", "translate(-7,0)")
        .style("fill",  color('spent'));

    spentTextBox.append('text')
      .attr("dy", ".35em")
      .attr("transform", "translate(-16,0)")
      .style("text-anchor", "end")
      .text('spent');

    var spt = spentTextBox.append('text')
      .attr("dy", ".35em")
      .attr("transform", "translate(2,0)")
      .style("text-anchor", "start");

    animateText(svt, saved);
    animateText(spt, debits.amount);
  });
})();
