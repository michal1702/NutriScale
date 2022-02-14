
import 'package:flutter/material.dart';
import 'package:food_app/config/physical_activity.dart';
import 'package:food_app/screens/common/text.dart';

import '../../constants.dart';

class DropdownActivityPicker extends StatefulWidget {
  DropdownActivityPicker({
    Key? key,
    required this.size,
    required this.onActivitySelect,
    this.activity
  }) : super(key: key);

  final Size size;
  final Function(String) onActivitySelect;
  PhysicalActivity? activity;

  @override
  _DropdownActivityPickerState createState() => _DropdownActivityPickerState();
}

class _DropdownActivityPickerState extends State<DropdownActivityPicker> {
  String dropdownValue = PhysicalActivity.Sedentary_Lifestyle.toShortString();

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.activity?.toShortString() ?? PhysicalActivity.Sedentary_Lifestyle.toShortString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size.height * 0.08,
      width: double.infinity,
      decoration: BoxDecoration(
          color: textWhiteColor,
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
          boxShadow: [
            BoxShadow(
              color: shadowBlackColor,
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: Offset(0.0, 4.0),
            )
          ]),
      child: DropdownButton<String>(
        icon: Visibility(visible: false, child: Icon(Icons.arrow_downward)),
        value: dropdownValue,
        style: buildHintTextStyle(textBlackColor),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
            widget.onActivitySelect(dropdownValue);
          });
        },
        items: <String>[
          PhysicalActivity.Sedentary_Lifestyle.toShortString(),
          PhysicalActivity.Lightly_Active_Lifestyle.toShortString(),
          PhysicalActivity.Moderately_Active_Lifestyle.toShortString(),
          PhysicalActivity.Very_Active_Lifestyle.toShortString(),
          PhysicalActivity.Extra_Active_Lifestyle.toShortString()
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: EdgeInsets.only(left: 15.0, top: 15.0),
              child: Text(
                value,
                style: buildHintTextStyle(textBlackColor),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}