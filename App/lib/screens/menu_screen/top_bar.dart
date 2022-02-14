import 'package:flutter/material.dart';
import 'package:food_app/model/user.dart';
import 'package:food_app/screens/common/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({
    Key? key,
    required this.size,
    required User user,
  })   : _user = user,
        super(key: key);

  final Size size;
  final User _user;

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return PreferredSize(
      preferredSize: Size.fromHeight(size.height * 0.08),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        shape: ContinuousRectangleBorder(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
        ),
        title: Text(
          '${localization.welcome} ${ _user.userCredentials.login}',
          style: buildHeaderTextStyle(textWhiteColor),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(size.height * 0.08);
}
