import 'package:flutter/material.dart';
import 'package:food_app/screens/common/text.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../constants.dart';

class ScaleIndicatorWidget extends StatefulWidget {
  ScaleIndicatorWidget({
    Key? key, required this.weight,
  }) : super(key: key);

  String weight = "0";

  @override
  _ScaleIndicatorWidgetState createState() => _ScaleIndicatorWidgetState();
}

class _ScaleIndicatorWidgetState extends State<ScaleIndicatorWidget> {
  @override
  Widget build(BuildContext context) {
    double thickness = 20.0;
    return SfRadialGauge(
      enableLoadingAnimation: true,
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0.0,
          maximum: 5.0,
          labelOffset: thickness,
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                angle: 90,
                verticalAlignment: GaugeAlignment.near,
                widget: Text(
                  '${widget.weight}kg',
                  style: buildTitleTextStyle(textBlackColor),
                ))
          ],
          axisLabelStyle: GaugeTextStyle(
            fontFamily: defaultFont,
            fontSize: 20.0,
          ),
          axisLineStyle: AxisLineStyle(
            thickness: thickness,
          ),
          pointers: <GaugePointer>[
            RangePointer(
                value: double.parse(widget.weight),
                width: thickness,
                gradient: SweepGradient(
                    colors: <Color>[lighterPrimary, primaryColor],
                    stops: <double>[0.10, 0.90]))
          ],
        )
      ],
    );
  }
}
