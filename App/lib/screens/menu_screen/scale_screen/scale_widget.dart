import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_app/constants.dart';
import 'package:food_app/controller/meals_controllers/product_controller.dart';
import 'package:food_app/model/nutrient.dart';
import 'package:food_app/model/product.dart';
import 'package:food_app/screens/common/rounded_button.dart';
import 'package:food_app/screens/common/text.dart';
import 'package:food_app/screens/menu_screen/scale_screen/scale_indicator_widget.dart';

import '../../../notifications_service.dart';

class ScaleWidget extends StatefulWidget {
  ScaleWidget({
    Key? key,
    required this.product,
    required this.onShowScaleScreen,
  }) : super(key: key);

  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> deviceList = List.empty(growable: true);
  final Product product;
  final Function(bool) onShowScaleScreen;

  @override
  _ScaleWidgetState createState() => _ScaleWidgetState();
}

class _ScaleWidgetState extends State<ScaleWidget> {
  AppLocalizations? _localization;
  final _notificationsService = NotificationService();
  final _productController = ProductController();
  int _tempProductWeight = 0;
  List<String> _tempNutrientsList = List.empty(growable: true);
  BluetoothDevice? _connectedDevice;
  List<BluetoothService> _services = List.empty();
  String _weight = "0.000"; //temporary - remove after blouetooth connect
  bool _showScale = false;
  bool _isSearching = true;

  @override
  void initState() {
    super.initState();
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        if (device.name == "Waga") {
          _addDeviceTolist(device);
          widget.flutterBlue.stopScan();
        }
      }
    });
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        if (result.device.name == "ESP32_Scale") {
          _addDeviceTolist(result.device);
          widget.flutterBlue.stopScan();
        }
      }
    });
    widget.flutterBlue.startScan();
  }

  @override
  Widget build(BuildContext context) {
    _localization = AppLocalizations.of(context)!;
    _tempNutrientsList.clear();
    widget.product.nutrientsList.forEach((element) {
      _tempNutrientsList.add("");
    });

    return !_showScale && _connectedDevice == null
        ? buildBluetoothScreen()
        : Container(
            child: Column(
              children: <Widget>[
                ScaleIndicatorWidget(weight: _weight),
                buildNutrientsList(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RoundedButton(
                      text: _localization!.back,
                      action: () async {
                        await widget.flutterBlue.stopScan();
                        widget.onShowScaleScreen(false);
                      },
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: primaryColor,
                      child: IconButton(
                        icon: Icon(Icons.check),
                        color: backgroundColor,
                        onPressed: () async {
                          for (int index = 0; index < widget.product.nutrientsList.length; index++) {
                            widget.product.nutrientsList[index].amount = _tempNutrientsList[index];
                          }
                          widget.product.weight = _tempProductWeight;
                          _productController.addProduct(widget.product);
                          final now = DateTime.now();
                          if (now.hour <= 17) {
                            _notificationsService.cancelNotification(0);
                            _notificationsService.showScheduledNotification(
                                'Remember to eat regularly',
                                'Your last meal was 3 hours ago');
                          }
                          final scaffold = ScaffoldMessenger.of(context);
                          scaffold.showSnackBar(
                            SnackBar(
                              duration: const Duration(milliseconds: 600),
                              content: Text(
                                _localization!.productWeighed,
                                style: buildHeaderTextStyle(textWhiteColor),
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: primaryColor,
                            ),
                          );
                          await widget.flutterBlue.stopScan();
                          widget.onShowScaleScreen(false);
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          );
  }

  Flexible buildNutrientsList() {
    if (_showScale) {
      final notifyService = _services.singleWhere(
              (element) => element.uuid
              .toString()
              .contains('4fafc201'));

      BluetoothCharacteristic _notifyCharacteristic = notifyService
          .characteristics
          .singleWhere((element) => element.uuid
          .toString()
          .contains('beb5483e'));

      Future.delayed(const Duration(milliseconds: 5), () async {
        _notifyCharacteristic.value.listen((value) {
          String message = "";
          value.forEach((element) {
            message += String.fromCharCode(element);
          });
          try{
            _weight = (double.parse(message)/1000).toStringAsFixed(3);
          } catch (e){
            print("Error while parsing");
          }
        });
        await _notifyCharacteristic.setNotifyValue(true);
        setState(() {});
      });
    }
    return Flexible(
      child: GridView.builder(
        itemCount: widget.product.nutrientsList.length,
        itemBuilder: (context, index) {
          double amount = _calculateAmount(widget.product.nutrientsList[index]);
          _tempNutrientsList[index] = amount.toStringAsFixed(2);
          _tempProductWeight = (double.parse(_weight) * 1000).toInt();
          return Text(
            '${widget.product.nutrientsList[index].name}\n${amount.toStringAsFixed(2)}${widget.product.nutrientsList[index].unit}',
            style: buildMediumTextStyle(textBlackColor),
            textAlign: TextAlign.center,
          );
        },
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300.0, mainAxisExtent: 70.0),
      ),
    );
  }

  Container buildBluetoothScreen() {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          Text(
            "Connect with Bluetooth",
            style: buildHeaderTextStyle(textBlackColor),
          ),
          SizedBox(height: 20.0),
          _isSearching
              ? Column(
                  children: <Widget>[
                    SpinKitFadingCircle(
                      size: 50.0,
                      color: primaryColor,
                    ),
                    SizedBox(height: 20.0),
                    RoundedButton(
                      text: 'Cancel',
                      action: () {
                        widget.onShowScaleScreen(false);
                      },
                    )
                  ],
                )
              : Column(
                  children: <Widget>[
                    Text(
                      "Kitchen scale found.",
                      style: buildBigTextStyle(textBlackColor),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Click connect to proceed.",
                      style: buildBigTextStyle(textBlackColor),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.0),
                    RoundedButton(
                        text: "Connect",
                        action: () async {
                          for (BluetoothDevice device in widget.deviceList) {
                            try {
                              setState(() {
                                _isSearching = true;
                              });
                              await device.connect();
                              setState(() {
                                _isSearching = false;
                              });
                            } catch (e) {
                              print("Error");
                            } finally {
                              _services = await device.discoverServices();
                              setState(() {
                                _showScale = true;
                              });
                            }
                            setState(() {
                              _connectedDevice = device;
                            });
                          }
                        }),
                    SizedBox(height: 20.0),
                    RoundedButton(
                      text: 'Cancel',
                      action: () {
                        widget.onShowScaleScreen(false);
                      },
                    )
                  ],
                )
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.flutterBlue.stopScan();
    _connectedDevice?.disconnect();
    super.dispose();
  }

  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.deviceList.contains(device)) {
      setState(() {
        widget.deviceList.add(device);
        _isSearching = false;
      });
    }
  }

  double _calculateAmount(Nutrient nutrient) {
    return double.parse(nutrient.amount) * double.parse(_weight) * 1000;
  }
}
