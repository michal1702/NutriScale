import 'package:flutter/material.dart';
import 'package:food_app/constants.dart';
import 'package:food_app/screens/common/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../common/rounded_button.dart';

class SignUpContainer extends StatelessWidget {
  const SignUpContainer({
    Key? key,
    required this.size,
    required this.text,
  }) : super(key: key);

  final Size size;
  final String text;

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return Container(
      child: Column(
        children: [
          Text(
            text,
            style: buildBigTextStyle(textBlackColor),
          ),
          SizedBox(height: 10.0),
          RoundedButton(
            text: localization.signUp,
            action: () {
              Navigator.pushNamed(context, '/register');
            },
          ),
        ],
      ),
    );
  }
}
