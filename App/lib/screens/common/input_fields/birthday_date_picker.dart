import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants.dart';
import '../text.dart';

class BirthdayDatePicker extends StatefulWidget {
  BirthdayDatePicker(
      {Key? key,
      required this.size,
      required this.isError,
      required this.onDateSelect})
      : super(key: key);

  final Size size;
  final Function(String) onDateSelect;
  bool isError = false;

  @override
  _BirthdayDatePickerState createState() => _BirthdayDatePickerState();
}

class _BirthdayDatePickerState extends State<BirthdayDatePicker> {
  String _date = '';
  AppLocalizations? localization;

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;
    return Container(
      height: widget.size.height * 0.08,
      width: double.infinity,
      decoration: BoxDecoration(
          color: textWhiteColor,
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
          border: Border.all(
              color: widget.isError ? errorColor : textWhiteColor, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: shadowBlackColor,
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: Offset(0.0, 4.0),
            )
          ]),
      child: GestureDetector(
        onTap: () {
          showDatePicker(
            context: context,
            initialDate: DateTime(DateTime.now().year - 5, DateTime.now().month, DateTime.now().day),
            firstDate: DateTime(1900),
            lastDate: DateTime(DateTime.now().year - 5, DateTime.now().month,  DateTime.now().day),
          ).then((date) {
            setState(() {
              _date = DateFormat('dd/MM/yyyy').format(date!);
              widget.onDateSelect(_date);
            });
          }).onError((error, stackTrace) {});
        },
        child: Padding(
          padding: EdgeInsets.only(left: 15.0, top: 15.0),
          child: Text(
            '${localization!.birthDate}  $_date',
            style: buildHintTextStyle(_date.isEmpty ? shadowBlackColor : textBlackColor),
          ),
        ),
      ),
    );
  }
}
