import 'package:flutter/material.dart';

import 'navigation_manager.dart';

class NavigationService extends INavigationService {
  static final NavigationService _instance = NavigationService._init();
  static NavigationService get instance => _instance;
  NavigationService._init();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  final removeAllOldRoutes = (Route<dynamic> route) => false;
  @override
  Future<void> navigateToPage(
      {required String path, Object? object, VoidCallback? onPress}) async {
    await navigatorKey.currentState?.pushNamed(path, arguments: object);
  }

  @override
  Future<void> navigateToPageRemovedUntil(
      {required String path, Object? object}) async {
    await navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(path, removeAllOldRoutes, arguments: object);
  }

  @override
  Future<void> navigateToPushReplacement(
      {required String path, Object? object}) async {
    await navigatorKey.currentState
        ?.pushReplacementNamed(path, arguments: object);
  }
}
