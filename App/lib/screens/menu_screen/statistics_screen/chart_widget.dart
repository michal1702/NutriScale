import 'package:flutter/material.dart';
import 'package:food_app/model/chart_record.dart';
import 'package:food_app/screens/common/text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../constants.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget(
      {Key? key, required this.chartRecords, required this.nutrient})
      : super(key: key);

  final List<ChartRecord> chartRecords;
  final String nutrient;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(
          text: nutrient, textStyle: buildSmallTextStyle(textBlackColor)),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        zoomMode: ZoomMode.xy,
        enablePanning: true,
      ),
      trackballBehavior: TrackballBehavior(
          // Enables the trackball
          enable: true,
          tooltipSettings: InteractiveTooltip(
              enable: true,
              color: textWhiteColor,
              textStyle:
                  TextStyle(color: textBlackColor, fontFamily: defaultFont))),
      primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.days,
      ),
      series: <ChartSeries>[
        ColumnSeries<ChartRecord, DateTime>(
            color: primaryColor,
            dataSource: chartRecords,
            xValueMapper: (ChartRecord chartRecord, _) => chartRecord.dateTime,
            yValueMapper: (ChartRecord chartRecord, _) => chartRecord.amount,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                topLeft: Radius.circular(10.0)))
      ],
    );
  }
}
