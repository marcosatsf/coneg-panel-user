import 'dart:async';

import 'package:coneg_panel_user/models/design_color_model.dart';
import 'package:coneg_panel_user/models/request_model.dart';
import 'package:coneg_panel_user/widget/allData.dart';
import 'package:coneg_panel_user/widget/dailyData.dart';
import 'package:coneg_panel_user/widget/infoData.dart';
import 'package:coneg_panel_user/widget/predictionData.dart';
import 'package:coneg_panel_user/widget/usageData.dart';
import 'package:coneg_panel_user/widget/weeklyData.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:rive/rive.dart';
import 'package:intl/intl.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  GetIt.I.registerSingleton(ConegDesign());

  runApp(Home());
}

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "ConEg PaTra - ConEg Painel da Transparência",
        theme: ThemeData(
            splashColor: Color(0xFF1F41B4),
            textTheme: GoogleFonts.ubuntuTextTheme(),
            canvasColor: Colors.black54),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF23A39B),
            title: Padding(
              padding: EdgeInsets.all(60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: <Widget>[
                      // Stroked text as border.
                      Text(
                        "ConEg",
                        style: TextStyle(
                          fontSize: 20,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6
                            ..color = ConegDesign().getBlue(),
                        ),
                      ),
                      // Solid text as fill.
                      Text(
                        "ConEg",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Image.asset(
                      'assets/images/ConEg.png',
                      height: 50,
                      width: 50,
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      // Stroked text as border.
                      Text(
                        "PaTra",
                        style: TextStyle(
                          fontSize: 20,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6
                            ..color = ConegDesign().getBlue(),
                        ),
                      ),
                      // Solid text as fill.
                      Text(
                        "PaTra",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // RiveAnimation.asset(
              //   'assets/coneg_gif.riv',
              // )
            ),
            centerTitle: true,
          ),
          backgroundColor: Color(0xFF006E68),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: DashboardUser(),
          ),
        ));
  }
}

class DashboardUser extends StatefulWidget {
  DashboardUser({Key key}) : super(key: key);

  @override
  _DashboardUserState createState() => _DashboardUserState();
}

class _DashboardUserState extends State<DashboardUser> {
  ConegDesign design = GetIt.I<ConegDesign>();
  String local;
  Map<String, dynamic> res;
  Map<String, dynamic> _buildPkt = {
    '0,0': {'module': '-', 'name': 'Vazio', 'size': 1},
    '0,1': {'module': '-', 'name': 'Vazio', 'size': 1},
    '1,0': {'module': '-', 'name': 'Vazio', 'size': 1},
    '1,1': {'module': '-', 'name': 'Vazio', 'size': 1},
  };

  List<Widget> constructor = [
    CircularProgressIndicator(),
    CircularProgressIndicator(),
    CircularProgressIndicator(),
    CircularProgressIndicator()
  ];
  Timer caller;
  Duration callerDuration = Duration(seconds: 10);
  String nowInfoFormatted;
  bool isDoubleSized = false;

  @override
  void initState() {
    super.initState();
    _loadData(local, true);
    caller = Timer.periodic(callerDuration, (e) {
      _loadData(local, false);
      print(e.tick);
    });
  }

  void _loadData(String where, bool option) async {
    _buildPkt = await RequestConeg().getJson(endpoint: '/setup_user');
    _buildWidgets(option);
  }

  void _buildWidgets(bool option) async {
    DateTime now = DateTime.now();
    List<Widget> tmpConstructor = List.empty(growable: true);
    String tmpString;
    List<String> tmpListString = List.empty(growable: true);
    for (var coord in _buildPkt.keys) {
      List<String> tmpModule = _buildPkt[coord]['module'].split(".");
      print(tmpModule);

      if (_buildPkt[coord]['module'] == '-')
        tmpString = 'Vazio';
      else {
        if (tmpModule[1] == 'timeseries' || tmpModule[1] == 'allinfodata')
          tmpString = "${DateFormat('dd/MM/yyyy').format(now)}.${tmpModule[1]}";
        else {
          tmpString = '${tmpModule[0]}.${tmpModule[1]}';
        }
      }

      tmpListString.add(tmpString);
    }
    res = await RequestConeg()
        .getJsonListQuery(endpoint: '/data_to_user', query: tmpListString);

    tmpConstructor.add(Container(
      decoration: BoxDecoration(
          color: Color(0xFF17DFD3),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 5, color: Color(0xFF23A39B))),
      child: Text(
        'CM : Cadastrado com Máscara',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ));
    tmpConstructor.add(Container(
      decoration: BoxDecoration(
          color: Color(0xFF17DFD3),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 5, color: Color(0xFF23A39B))),
      child: Text(
        'DSM : Descadastrado sem Máscara',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ));
    tmpConstructor.add(Container(
      decoration: BoxDecoration(
          color: Color(0xFF17DFD3),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 5, color: Color(0xFF23A39B))),
      child: Text(
        'CSM : Cadastrado sem Máscara',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ));

    for (var coord in _buildPkt.keys) {
      if (_buildPkt[coord]['name'] != 'Vazio') {
        List<String> tmpModule = _buildPkt[coord]['module'].split(".");
        switch (tmpModule[1]) {
          case 'weeklydata':
            tmpConstructor.add(_buildContainer(
                WeeklyData(
                  data: res[coord][tmpModule[1]],
                  info: _buildPkt[coord]['name'],
                  animate: option,
                ),
                h: 400,
                w: 450));
            break;
          case 'usagedata':
            tmpConstructor.add(_buildContainer(
                UsageData(
                  data: res[coord][tmpModule[1]],
                  info: _buildPkt[coord]['name'],
                  animate: option,
                ),
                h: 400,
                w: 450));
            break;
          case 'infodata':
            tmpConstructor.add(_buildContainer(
                InfoData(
                    data: res[coord][tmpModule[1]],
                    titulo: _buildPkt[coord]['name']),
                h: 400,
                w: 450));
            break;
          case 'dailydata':
            tmpConstructor.add(_buildContainer(
                DailyData(
                  data: res[coord][tmpModule[1]],
                  info: _buildPkt[coord]['name'],
                  animate: option,
                ),
                h: 400,
                w: 450));
            break;
          case 'timeseries':
            if (isDoubleSized == false) {
              tmpConstructor.add(_buildContainer(
                  PredictionData(
                    data: res[coord][tmpModule[1]]['prediction'],
                    location: res[coord][tmpModule[1]]['locale'],
                    animate: option,
                  ),
                  h: 400));
              isDoubleSized = true;
            } else {
              isDoubleSized = false;
            }
            break;
          case 'allinfodata':
            if (isDoubleSized == false) {
              tmpConstructor.add(_buildContainer(
                  AllData(
                    data: res[coord][tmpModule[1]],
                    info: _buildPkt[coord]['name'],
                    animate: true,
                  ),
                  h: 400));
              isDoubleSized = true;
            } else {
              isDoubleSized = false;
            }
            break;
          default:
            tmpConstructor.add(
                _buildContainer(CircularProgressIndicator(), h: 400, w: 450));
        }
      } else {
        tmpConstructor.add(_buildContainer(
            RiveAnimation.asset(
              'assets/coneg_gif.riv',
            ),
            h: 400,
            w: 450));
      }
      setState(() {
        constructor = tmpConstructor;
      });
    }
  }

  @override
  void dispose() {
    caller.cancel();
    super.dispose();
  }

  Widget _buildContainer(Widget childWidget, {double h, double w}) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFF17DFD3),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(width: 5, color: Color(0xFF23A39B))),
      child: childWidget,
      height: h != null ? h : 900,
      width: w != null ? w : 900,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: 1000,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.spaceEvenly,
            children: constructor,
          ),
        ),
      ),
    );
  }
}
