import 'package:coneg_panel_user/models/design_color_model.dart';

/// Bar chart example
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get_it/get_it.dart';

class AllData extends StatelessWidget {
  final Map<String, dynamic> data;
  final String info;
  final bool animate;

  AllData({this.data, this.info, this.animate});

  ConegDesign allDataDesign = GetIt.I<ConegDesign>();

  Widget _buildRow() {
    List<Widget> children = List.empty(growable: true);
    for (var cams in data.keys) {
      children.add(Flexible(
          child: Column(
        children: [
          Stack(
            children: <Widget>[
              // Stroked text as border.
              Text(
                cams,
                style: TextStyle(
                  fontSize: 15,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 6
                    ..color = Color(0xFF1F41B4),
                ),
              ),
              // Solid text as fill.
              Text(
                cams,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),
          Flexible(
              child:
                  GroupedFillColorBarChart.transformData(data[cams], animate))
        ],
      )));
    }
    return Row(children: children);
  }

  @override
  Widget build(BuildContext context) {
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
                    info,
                    style: TextStyle(
                      fontSize: 18,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6
                        ..color = allDataDesign.getBlue(),
                    ),
                  ),
                  // Solid text as fill.
                  Text(
                    info,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ],
          )),
      SizedBox(height: 300, width: 800, child: _buildRow()),
    ];

    return new Column(
        crossAxisAlignment: CrossAxisAlignment.center, children: children);
  }
}

class GroupedFillColorBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  GroupedFillColorBarChart(this.seriesList, {this.animate});

  factory GroupedFillColorBarChart.transformData(
      List<dynamic> data, bool animate) {
    return new GroupedFillColorBarChart(
      _createSampleData(data),
      animate: animate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.BarRendererConfig(
          strokeWidthPx: 2.0,
          barRendererDecorator: charts.BarLabelDecorator<String>()),
      domainAxis: new charts.OrdinalAxisSpec(),
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalCases, String>> _createSampleData(
      List<dynamic> data) {
    final allStatusData = [
      new OrdinalCases('CM', data[0]), //CM
      new OrdinalCases('DSM', data[1]), //DSM
      new OrdinalCases('CSM', data[2]) //CSM
    ];

    return [
      // Blue bars with a lighter center color.
      new charts.Series<OrdinalCases, String>(
          id: 'Utilizacao',
          domainFn: (OrdinalCases sales, _) => sales.status,
          measureFn: (OrdinalCases sales, _) => sales.cases,
          data: allStatusData,
          colorFn: (uso, __) {
            switch (uso.status) {
              case 'CM':
                return charts.ColorUtil.fromDartColor(
                    Colors.green.withOpacity(0.75));
                break;
              case 'DSM':
                return charts.ColorUtil.fromDartColor(
                    Colors.yellow.shade700.withOpacity(0.75));
                break;
              case 'CSM':
                return charts.ColorUtil.fromDartColor(
                    Colors.red.withOpacity(0.75));
                break;
              default:
                return charts.ColorUtil.fromDartColor(
                    Colors.blue.shade800.withOpacity(0.75));
                break;
            }
          },
          fillColorFn: (uso, __) {
            switch (uso.status) {
              case 'CM':
                return charts.ColorUtil.fromDartColor(Colors.green);
                break;
              case 'DSM':
                return charts.ColorUtil.fromDartColor(Colors.yellow.shade700);
                break;
              case 'CSM':
                return charts.ColorUtil.fromDartColor(Colors.red);
                break;
              default:
                return charts.ColorUtil.fromDartColor(Colors.blue.shade800);
                break;
            }
          },
          labelAccessorFn: (uso, __) => '${uso.cases.toString()}'),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalCases {
  final String status;
  final int cases;

  OrdinalCases(this.status, this.cases);
}
