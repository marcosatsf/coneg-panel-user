import 'package:charts_flutter/flutter.dart' as charts;
import 'package:coneg_panel_user/models/design_color_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class DailyData extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool animate;
  final String info;

  DailyData({this.data, this.info, this.animate});

  @override
  Widget build(BuildContext context) {
    return SelectionCallbackExample.transformData(data, info, animate);
  }
}

class SelectionCallbackExample extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final String info;

  SelectionCallbackExample(this.seriesList, {this.info, this.animate});

  /// Creates a [charts.TimeSeriesChart] with sample data and no transition.
  factory SelectionCallbackExample.transformData(
      Map<String, dynamic> map, String info, bool animate) {
    return new SelectionCallbackExample(
      _createSampleData(map),
      info: info,
      animate: animate,
    );
  }

  // We need a Stateful widget to build the selection details with the current
  // selection as the state.
  @override
  State<StatefulWidget> createState() => new _SelectionCallbackState();

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesCases, DateTime>> _createSampleData(
      Map<String, dynamic> map) {
    List<TimeSeriesCases> status0 = List.empty(growable: true);
    for (var day in map['0']) {
      status0.add(TimeSeriesCases(DateTime.parse(day[0]), day[1]));
    }
    List<TimeSeriesCases> status1 = List.empty(growable: true);
    for (var day in map['1']) {
      status1.add(TimeSeriesCases(DateTime.parse(day[0]), day[1]));
    }
    List<TimeSeriesCases> status2 = List.empty(growable: true);
    for (var day in map['2']) {
      status2.add(TimeSeriesCases(DateTime.parse(day[0]), day[1]));
    }

    return [
      new charts.Series<TimeSeriesCases, DateTime>(
        id: 'Status 0',
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Colors.greenAccent.shade700),
        domainFn: (TimeSeriesCases sales, _) => sales.time,
        measureFn: (TimeSeriesCases sales, _) => sales.qtd,
        data: status0,
      ),
      new charts.Series<TimeSeriesCases, DateTime>(
        id: 'Status 1',
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Colors.yellowAccent.shade700),
        domainFn: (TimeSeriesCases sales, _) => sales.time,
        measureFn: (TimeSeriesCases sales, _) => sales.qtd,
        data: status1,
      ),
      new charts.Series<TimeSeriesCases, DateTime>(
        id: 'Status 2',
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Colors.redAccent.shade700),
        domainFn: (TimeSeriesCases sales, _) => sales.time,
        measureFn: (TimeSeriesCases sales, _) => sales.qtd,
        data: status2,
      )
    ];
  }
}

class _SelectionCallbackState extends State<SelectionCallbackExample> {
  DateTime _time;
  Map<String, num> _measures;
  ConegDesign dailyDesign = GetIt.I<ConegDesign>();
  String dailyData;

  // Listens to the underlying selection changes, and updates the information
  // relevant to building the primitive legend like information under the
  // chart.
  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime time;
    final measures = <String, num>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
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
    dailyData = widget.info;
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
                    dailyData,
                    style: TextStyle(
                      fontSize: 18,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6
                        ..color = dailyDesign.getBlue(),
                    ),
                  ),
                  // Solid text as fill.
                  Text(
                    dailyData,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ],
          )),
      SizedBox(
        height: 250,
        width: 420,
        child: new charts.TimeSeriesChart(
          widget.seriesList,
          animate: widget.animate,
          selectionModels: [
            new charts.SelectionModelConfig(
              type: charts.SelectionModelType.info,
              changedListener: _onSelectionChanged,
            )
          ],
        ),
      ),
    ];

    // If there is a selection, then include the details.
    if (_time != null) {
      children.add(new Padding(
          padding: new EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: new Text(
            DateFormat('dd/MM/yyyy - HH:mm').format(_time),
            //"Data: ${_time.day}/${_time.month}/${_time.year}",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          )));
    }
    _measures?.forEach((String series, num value) {
      switch (series) {
        case 'Status 0':
          children.add(new Padding(
              padding: EdgeInsets.only(top: 2.5, bottom: 2.5),
              child: Stack(
                children: <Widget>[
                  Text(
                    'Com máscara (CM) [qtd]: $value',
                    style: TextStyle(
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 3
                          ..color = Colors.black),
                  ),
                  Text(
                    'Com máscara (CM) [qtd]: $value',
                    style: TextStyle(
                        color: Colors.greenAccent.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )));
          break;
        case 'Status 1':
          children.add(new Padding(
              padding: EdgeInsets.only(top: 2.5, bottom: 2.5),
              child: Stack(
                children: <Widget>[
                  Text(
                    'Desconhecido sem máscara (DSM) [qtd]: $value',
                    style: TextStyle(
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 3
                          ..color = Colors.black),
                  ),
                  Text(
                    'Desconhecido sem máscara (DSM) [qtd]: $value',
                    style: TextStyle(
                        color: Colors.yellowAccent.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )));
          break;
        case 'Status 2':
          children.add(new Padding(
              padding: EdgeInsets.only(top: 2.5, bottom: 2.5),
              child: Stack(
                children: <Widget>[
                  Text(
                    'Cadastrado sem máscara (CSM) [qtd]: $value',
                    style: TextStyle(
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 3
                          ..color = Colors.black),
                  ),
                  Text(
                    'Cadastrado sem máscara (CSM) [qtd]: $value',
                    style: TextStyle(
                        color: Colors.redAccent.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )));
          break;
        default:
      }
    });

    return new Column(
        crossAxisAlignment: CrossAxisAlignment.center, children: children);
  }
}

class TimeSeriesCases {
  final DateTime time;
  final int qtd;

  TimeSeriesCases(this.time, this.qtd);
}
