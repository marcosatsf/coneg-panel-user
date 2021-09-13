import 'package:coneg_panel_user/models/design_color_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class InfoData extends StatelessWidget {
  final List data;
  final ConegDesign infoDataDesign = GetIt.I<ConegDesign>();
  final String titulo;

  InfoData({this.data, this.titulo});

  List<Widget> _buildText() {
    List<Widget> tmp = List.empty(growable: true);

    TextStyle textInfo(Color tColor) => TextStyle(fontSize: 20, color: tColor);

    tmp.add(Flexible(
        child: Container(
      child: Center(
        child: Text(
          "Maior fluxo recente sem máscara",
          style: textInfo(Colors.white),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.redAccent.shade700,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
    )));

    if (data.length == 3)
      tmp.add(Flexible(
          child: Row(
        children: [
          Expanded(
            child: Container(
              child: Center(
                child: Text(
                  data[0][0].toString(),
                  style: textInfo(Colors.redAccent.shade700),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: Text(
                  DateFormat('dd/MM/yyyy').format(DateTime.parse(data[0][1])),
                  style: textInfo(Colors.white),
                ),
              ),
              color: Colors.redAccent.shade700,
            ),
          ),
        ],
      )));
    else
      tmp.add(Flexible(
          child: Row(
        children: [
          Expanded(
            child: Container(
              child: Center(
                child: Text(
                  '-',
                  style: textInfo(Colors.redAccent.shade700),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: Text(
                  '-',
                  style: textInfo(Colors.white),
                ),
              ),
              color: Colors.redAccent.shade700,
            ),
          ),
        ],
      )));

    tmp.add(Flexible(
        child: Container(
      child: Center(
        child: Text(
          "Menor fluxo recente sem máscara",
          style: textInfo(Colors.white),
        ),
      ),
      color: Colors.green.shade800,
    )));

    if (data.length == 3)
      tmp.add(Flexible(
          child: Row(
        children: [
          Expanded(
            child: Container(
              child: Center(
                child: Text(
                  data[1][0].toString(),
                  style: textInfo(Colors.green.shade800),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: Text(
                  DateFormat('dd/MM/yyyy').format(DateTime.parse(data[1][1])),
                  style: textInfo(Colors.white),
                ),
              ),
              color: Colors.green.shade800,
            ),
          ),
        ],
      )));
    else
      tmp.add(Flexible(
          child: Row(
        children: [
          Expanded(
            child: Container(
              child: Center(
                child: Text(
                  '-',
                  style: textInfo(Colors.green.shade800),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: Text(
                  '-',
                  style: textInfo(Colors.white),
                ),
              ),
              color: Colors.green.shade800,
            ),
          ),
        ],
      )));

    tmp.add(Flexible(
        child: Container(
      child: Center(
        child: Text(
          "Contador de pessoas para hoje",
          style: textInfo(Colors.white),
        ),
      ),
      color: Colors.blue.shade900,
    )));

    if (data.length == 3)
      tmp.add(Flexible(
        child: Container(
          child: Center(
            child: Text(
              data[2][0].toString(),
              style: textInfo(Colors.blue.shade900),
            ),
          ),
        ),
      ));
    else
      tmp.add(Flexible(
        child: Container(
          child: Center(
            child: Text(
              '-',
              style: textInfo(Colors.blue.shade900),
            ),
          ),
        ),
      ));

    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: <Widget>[
                    // Stroked text as border.
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 18,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 6
                          ..color = infoDataDesign.getBlue(),
                      ),
                    ),
                    // Solid text as fill.
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ],
            )),
        ..._buildText(),
      ],
    );
  }
}
