import 'package:flutter/material.dart';

import '../../tool/constants/color_constants.dart';
import 'model/onboard_model.dart';

class PageIndicator extends StatefulWidget {
  const PageIndicator({Key? key, required this.selectedIndex})
      : super(key: key);
  final int selectedIndex;

  @override
  _PageIndicatorState createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void didUpdateWidget(covariant PageIndicator oldWidget) {
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _tabController.animateTo(widget.selectedIndex);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _tabController = TabController(
        length: OnBoardModels.onBoardPageItems.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 900),
      child: TabPageSelector(
        selectedColor: SystemColor.colorRedMain,
        indicatorSize: 9,
        controller: _tabController,
      ),
    );
  }
}
