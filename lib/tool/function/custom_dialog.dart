import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/lang/locale_keys.g.dart';

void showCustomDialog(
    {required BuildContext context,
    required Text? title,
    required Widget widget,
    required VoidCallback onPressedOk,
    required VoidCallback onPressedCancel}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          widget,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: onPressedOk,
                child: const Text(LocaleKeys.my_notes_btn_ok).tr(),
              ),
              TextButton(
                onPressed: onPressedCancel,
                child: const Text(LocaleKeys.my_notes_btn_cancel).tr(),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
