import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_app/config/available_nutrients.dart';
import 'package:food_app/controller/food_controllers/meals_controller.dart';
import 'package:food_app/model/chart_record.dart';
import 'package:food_app/model/meal.dart';
import 'package:food_app/screens/common/text.dart';

import '../../../constants.dart';
import 'chart_widget.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key, required this.size}) : super(key: key);

  final Size size;

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  AppLocalizations? localization;
  final _mealsController = MealsController();
  List<Meal> _mealsList = List.empty();

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;
    Future<List<Meal>> mealsFuture = _mealsController
        .getAllMeals()
        .then((mealsList) => _mealsList = mealsList);
    return Container(
      child: FutureBuilder(
          future: mealsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print('Error while connecting: ${snapshot.error.toString()}');
              return Text(
                localization!.nothingHasBeenWeighedRecently,
                style: buildMediumTextStyle(textBlackColor),
                textAlign: TextAlign.center,
              );
            } else if (snapshot.hasData) {
              if (_mealsList.isNotEmpty) {
                final nutrientsMap = mealsToNutrientsMap(_mealsList);
                return ListView.separated(
                  clipBehavior: Clip.none,
                  itemBuilder: (BuildContext context, int index) {
                    String key = nutrientsMap.keys.elementAt(index);
                    String unit =
                        key == localization!.calories ? '[kcal]' : '[g]';
                    return ChartWidget(
                        chartRecords: nutrientsMap[key]!,
                        nutrient: '$key $unit');
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 10.0),
                  itemCount:
                      AvailableNutrients.getAvailableNutrients()
                          .length,
                );
              } else {
                return Text(
                  localization!.nothingHasBeenWeighedRecently,
                  style: buildMediumTextStyle(textBlackColor),
                  textAlign: TextAlign.center,
                );
              }
            } else {
              return SpinKitFadingCircle(
                size: 80.0,
                color: primaryColor,
              );
            }
          }),
    );
  }
}

Map<String, List<ChartRecord>> mealsToNutrientsMap(List<Meal> meals) {
  Map<String, List<ChartRecord>> nutrientsMap = Map();

  for (var meal in meals) {
    for (var nutrient in meal.product.nutrientsList) {
      if (!nutrientsMap.containsKey(nutrient.name)) {
        List<ChartRecord> chartNutrients = List.empty(growable: true);
        nutrientsMap[nutrient.name] = chartNutrients;
        nutrientsMap[nutrient.name]!
            .add(ChartRecord(meal.dateTime, double.parse(nutrient.amount)));
      } else {
        final listItem = nutrientsMap[nutrient.name]!.singleWhere(
            (chartRecord) => _isSameDay(chartRecord.dateTime, meal.dateTime),
            orElse: () => ChartRecord(null, 0.0));
        if (listItem.dateTime != null) {
          int index = nutrientsMap[nutrient.name]!.indexOf(listItem);
          nutrientsMap[nutrient.name]![index].amount +=
              double.parse(nutrient.amount);
        } else {
          nutrientsMap[nutrient.name]!
              .add(ChartRecord(meal.dateTime, double.parse(nutrient.amount)));
        }
      }
    }
  }
  return nutrientsMap;
}

bool _isSameDay(DateTime? chartRecord, DateTime meal) {
  return chartRecord?.year == meal.year &&
      chartRecord?.month == meal.month &&
      chartRecord?.day == meal.day;
}
