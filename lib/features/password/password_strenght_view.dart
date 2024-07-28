import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/lang/locale_keys.g.dart';
import '../../tool/constants/color_constants.dart';
import '../../tool/constants/system_constants.dart';
import '../../tool/widget/password_strength_checker.dart';

enum PasswordStrength { Blank, VeryWeak, Weak, Medium, Strong, VeryStrong }

class PasswordStrenghtView extends StatefulWidget {
  const PasswordStrenghtView({Key? key}) : super(key: key);

  @override
  _PasswordStrenghtViewState createState() => _PasswordStrenghtViewState();
}

class _PasswordStrenghtViewState extends State<PasswordStrenghtView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  PasswordStrength _passwordStrength = PasswordStrength.Blank;
  final _controller = TextEditingController();
  String pass = "";
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animation.addListener(() {
      setState(() {});
    });
    // _setPasswordStrength();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(LocaleKeys.password_strength_title).tr(),
      ),
      body: Padding(
        padding: const SystemPadding.all(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlutterPasswordStrength(
              radius: 50,
              height: 50,
              password: pass,
            ),
            Padding(
              padding: const SystemPadding.onlyTop(),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    pass = value;
                  });
                },
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                controller: _controller,
                decoration: InputDecoration(
                  labelText: LocaleKeys.password_strength_password.tr(),
                  labelStyle: const TextStyle(fontSize: 12),
                  fillColor: SystemColor.black12,
                  filled: true,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
