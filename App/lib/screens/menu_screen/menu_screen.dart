import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_app/config/current_user.dart';
import 'package:food_app/screens/common/text.dart';
import 'package:food_app/screens/menu_screen/scale_screen/product_search_screen.dart';
import 'package:food_app/screens/menu_screen/statistics_screen/statistics_screen.dart';
import 'package:food_app/screens/menu_screen/top_bar.dart';

import '../../constants.dart';
import 'home_screen/home_screen.dart';
import 'settings_screen/settings_screen.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  AppLocalizations? localization;

  int _currentTabIndex = 0;
  int _previousTabIndex = 0;
  int _tabsLength = 0;

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: TopBar(size: size, user: CurrentUser.user!),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          topLeft: Radius.circular(40),
        ),
        child: buildBottomNavigationBar(),
      ),
      body: buildCenterContent(size),
    );
  }

  Center buildCenterContent(Size size) {
    final tabs = [
      Center(
        child: HomeScreen(size: size),
      ),
      Center(
        child: ProductSearchWidget(size: size),
      ),
      Center(
        child: StatisticsScreen(size: size),
      ),
      Center(
        child: SettingsWidget(size: size, user: CurrentUser.user!),
      )
    ];
    _tabsLength = tabs.length;
    return _currentTabIndex >= tabs.length
        ? tabs[_previousTabIndex]
        : tabs[_currentTabIndex];
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentTabIndex,
      backgroundColor: textWhiteColor,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryColor,
      unselectedItemColor: textBlackColor,
      iconSize: 28.0,
      selectedFontSize: 14.0,
      unselectedFontSize: 13.0,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: localization!.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.point_of_sale),
          label: localization!.scale,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          label: localization!.statistics,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: localization!.logOut,
        ),
      ],
      onTap: (index) {
        setState(() {
          if (index >= _tabsLength && index != _currentTabIndex) {
            _previousTabIndex = _currentTabIndex;
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: Text(localization!.logOut),
                      content: Text(
                        localization!.areYouSureYouWantToLogOut,
                        style: buildSmallTextStyle(textBlackColor),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            localization!.yes,
                            style: buildMediumTextStyle(primaryColor),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            localization!.no,
                            style: buildMediumTextStyle(primaryColor),
                          ),
                        ),
                      ],
                    ));
            _currentTabIndex = _previousTabIndex;
          } else
            _currentTabIndex = index;
        });
      },
    );
  }
}
