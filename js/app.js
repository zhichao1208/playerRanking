var app = angular.module('TrendingPlayers', ['chart.js','dndLists','ui.bootstrap.tabs','ui.bootstrap.tpls']);

 app.config(['ChartJsProvider', function (ChartJsProvider) {
    // Configure all charts
    ChartJsProvider.setOptions({
      responsive: true,
          });
    // Configure all line charts
    ChartJsProvider.setOptions('line', {
      showLines: true
    });
  }]);
