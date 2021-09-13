import 'package:coneg_panel_user/models/design_color_model.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class PredictionData extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool animate;
  final String location;

  PredictionData({this.data, this.animate, this.location});

  @override
  Widget build(BuildContext context) {
    return SelectionCallbackExample.transformData(data, animate, location);
  }
}

class SelectionCallbackExample extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final String location;

  SelectionCallbackExample(this.seriesList, {this.animate, this.location});

  /// Creates a [charts.TimeSeriesChart] with sample data and no transition.
  factory SelectionCallbackExample.transformData(
      Map<String, dynamic> map, bool animate, String location) {
    return new SelectionCallbackExample(
      _createSampleData(map),
      // Disable animations for image tests.
      animate: animate,
      location: location,
    );
  }

  // We need a Stateful widget to build the selection details with the current
  // selection as the state.
  @override
  State<StatefulWidget> createState() => new _SelectionCallbackState();

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesCases, String>> _createSampleData(
      Map<String, dynamic> map) {
    List<TimeSeriesCases> daysCases = List.empty(growable: true);
    for (var day in map.keys) {
      daysCases.add(TimeSeriesCases(DateTime.parse(day), map[day][1],
          predicted: map[day][0]));
    }
    return [
      new charts.Series<TimeSeriesCases, String>(
        id: 'Casos novos por dia',
        colorFn: (TimeSeriesCases ts, __) {
          switch (ts.predicted) {
            case 0:
              return charts.ColorUtil.fromDartColor(Colors.indigo.shade400);
              break;
            case 1:
              return charts.ColorUtil.fromDartColor(Colors.redAccent.shade700);
              break;
            default:
              return charts.ColorUtil.fromDartColor(Colors.indigo.shade400);
              break;
          }
        },
        domainFn: (TimeSeriesCases ts, int idx) =>
            DateFormat('dd/MM').format(ts.time),
        measureFn: (TimeSeriesCases ts, _) => ts.qtd,
        data: daysCases,
        labelAccessorFn: (TimeSeriesCases ts, _) => '${ts.qtd.toString()}',
      ),
    ];
  }
}

class _SelectionCallbackState extends State<SelectionCallbackExample> {
  DateTime _time;
  Map<String, num> _measures;
  ConegDesign weeklyDesign = GetIt.I<ConegDesign>();
  String predData = "Quadro Atual Regional de Predição para COVID-19";

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime time;
    final measures = <String, num>{};

    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.time;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.qtd;
      });
    }

    // Request a build.
    setState(() {
      _time = time;
      _measures = measures;
    });
  }

  @override
  Widget build(BuildContext context) {
    // The children consist of a Chart and Text widgets below to hold the info.
    final children = <Widget>[
      Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: <Widget>[
                  // Stroked text as border.
                  Text(
                    predData,
                    style: TextStyle(
                      fontSize: 18,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6
                        ..color = weeklyDesign.getBlue(),
                    ),
                  ),
                  // Solid text as fill.
                  Text(
                    predData,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ],
          )),
      Text(
          'Situação em ${widget.location} de ${DateFormat('dd/MM/yyyy').format(widget.seriesList.first.data.first.time)} para ${DateFormat('dd/MM/yyyy').format(widget.seriesList.first.data.last.time)}'),
      SizedBox(
          height: 300,
          child: charts.BarChart(
            widget.seriesList,
            animate: widget.animate,
            animationDuration: new Duration(seconds: 2),
            // Configure a stroke width to enable borders on the bars.
            defaultRenderer: new charts.BarRendererConfig(
                strokeWidthPx: 2.0,
                barRendererDecorator: charts.BarLabelDecorator<String>()),
          )),
    ];

    return new Column(
        crossAxisAlignment: CrossAxisAlignment.center, children: children);
  }
}

class TimeSeriesCases {
  final DateTime time;
  final int qtd;
  final int predicted;

  TimeSeriesCases(this.time, this.qtd, {this.predicted});
}
