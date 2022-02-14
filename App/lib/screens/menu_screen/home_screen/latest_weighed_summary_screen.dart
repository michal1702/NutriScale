import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_app/model/meal.dart';
import 'package:food_app/screens/common/text.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';

class LastWeighedSummaryScreen extends StatelessWidget {
  const LastWeighedSummaryScreen({Key? key, required this.meal})
      : super(key: key);

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    AppLocalizations? localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        shape: ContinuousRectangleBorder(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
        ),
        title: Text(
          '${meal.product.name}'.toUpperCase(),
          style: buildHeaderTextStyle(textWhiteColor),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 40),
          Image.network(meal.product.imgUrl),
          SizedBox(height: 40),
          Text(
            'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(meal.dateTime)}',
            style: buildBigTextStyle(textBlackColor),
          ),
          SizedBox(height: 40),
          Text(
            'Total weighed: ${meal.product.weight}[g]',
            style: buildBigTextStyle(textBlackColor),
          ),
          SizedBox(height: 40),
          Flexible(
            child: GridView.builder(
              itemCount: meal.product.nutrientsList.length,
              itemBuilder: (context, index) {
                return Text(
                  '${meal.product.nutrientsList[index].name}\n${meal.product.nutrientsList[index].amount}${meal.product.nutrientsList[index].unit}',
                  style: buildBigTextStyle(textBlackColor),
                  textAlign: TextAlign.center,
                );
              },
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300.0, mainAxisExtent: 70.0),
            ),
          )
        ],
      ),
    );
  }
}
