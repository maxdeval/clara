$(document).on('ready turbolinks:load', function () {
  if ($('body').hasClass('stats') && $('body').hasClass('index')) {
    /**
    * Load from PE / not from PE
    */
    var json_data = JSON.parse($('.ct-gape').attr('data-loaded'))["json_data"]
    var total_nb = _.chain(json_data)
                      .filter(function (e) {return e["Segment"] === "Tous les utilisateurs"}) 
                      .map(function (e) {return _.toNumber(e["Sessions"].match(/\d/g).join(""))})
                      .sum()
                      .value()
    
    var advisor_nb = _.chain(json_data)
                        .filter(function (e) {return e["Segment"] === "Conseillers PE"}) 
                        .map(function (e) {return _.toNumber(e["Sessions"].match(/\d/g).join(""))})
                        .sum()
                        .value()
    
    var asker_nb = total_nb - advisor_nb

    new Chartist.Bar(
      '.ct-gape',
      {
        series: [{ name: 'Conseillers ' + _.toPercentage(advisor_nb, total_nb), data: [advisor_nb] }, { name: 'Demandeurs ' + _.toPercentage(asker_nb, total_nb), data: [asker_nb] }]
      },
      {
        seriesBarDistance: 10,
        plugins: [Chartist.plugins.legend()],
        reverseData: true,
        horizontalBars: true,
        seriesBarDistance: 30,
        axisY: {
          offset: 70
        }
      }
    );


    /**
    * Load sessions
    */
    var json_data = JSON.parse($('.ct-gabarline').attr('data-loaded'))["json_data"]

    var grouped_board = _.groupBy(json_data, function(e) {
      return moment(e["Index des jours"], "DD/MM/YYYY").startOf('isoWeek');
    });

    var week_board = _.map(grouped_board, function(v, k) {
      return _.sum(_.map(v, function(m) {return _.toNumber(m["Sessions"].match(/\d/g).join(""))}))
    });

    var nice_keys = _.map(_.keys(grouped_board), function(e){var splitted = _.split(e, " "); return splitted[1] + " " + splitted[2] + " " + splitted[3];})


    new Chartist.Line(
      '.ct-gabarline',
      {
        labels: nice_keys,
        series: [week_board]
      },
      {
        height: 300,
        low: 0,
        showArea: true
      }
    );

  }
});
