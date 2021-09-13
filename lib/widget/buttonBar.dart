import 'package:coneg_panel_user/models/design_color_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CustomButtonBar extends StatelessWidget {
  final List<Widget> children;
  final List<bool> isSelected;
  final Function(int) onPressed;
  final ConegDesign design = GetIt.I<ConegDesign>();

  CustomButtonBar({this.children, this.isSelected, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 40,
      child: ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (context, index) => SizedBox(
          width: 15,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: children.length,
        itemBuilder: (context, index) {
          var button = children[index];
          var selected = isSelected[index];
          return MaterialButton(
            child: button,
            onPressed: () => onPressed(index),
            color: selected ? design.getBlue() : design.getPurple(),
            elevation: 10,
            highlightElevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            textColor: Colors.white,
          );
        },
      ),
    );
  }
}
