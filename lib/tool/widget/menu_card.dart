import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

class MenuCard extends StatelessWidget {
  final VoidCallback onTap;
  final Icon icon;
  final String title;
  const MenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: SystemColor.colorRedMain,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ).tr(),
            ),
          ],
        ),
      ),
    );
  }
}
