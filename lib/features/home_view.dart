
import 'package:easy_localization/easy_localization.dart';
import '../ad/google_ads.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../core/lang/locale_keys.g.dart';
import '../core/manage/navigation/navigation_service.dart';
import '../tool/constants/color_constants.dart';
import '../tool/constants/navigation_constants.dart';
import '../tool/constants/system_constants.dart';
import '../tool/extensions/app_extensions.dart';
import '../tool/widget/menu_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GoogleAds _googleAds = GoogleAds();

  @override
  void initState() {
    _googleAds.loadAd(
      adLoaded: () {},
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NavigationService navigation = NavigationService.instance;
    double iconSize = 80.0;
    return Scaffold(
        appBar: AppBar(
          title: const Text(SystemConstants.APP_TITLE),
          actions: [
            IconButton(
              onPressed: () {
                context.setLocale(
                  const Locale('tr', 'TR'),
                );
              },
              icon: ImagePaths.tr_flag.toWidget(),
            ),
            IconButton(
              onPressed: () {
                context.setLocale(
                  const Locale('en', 'US'),
                );
              },
              icon: ImagePaths.en_flag.toWidget(),
            )
          ],
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _googleAds.bannerAd != null
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.white,
                      width: 468,
                      height: 60,
                      child: AdWidget(ad: _googleAds.bannerAd!),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        body: Padding(
          padding: const SystemPadding.miniAll(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const SystemPadding.onlyMiniTop(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      color: SystemColor.black12,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const SystemPadding.miniAll(),
                            child: Text(LocaleKeys.home_description,
                                    style:
                                        Theme.of(context).textTheme.titleMedium)
                                .tr(),
                          ),
                        ),
                        SizedBox(
                            height: 200,
                            child: Padding(
                                padding: const SystemPadding.miniAll(),
                                child: ImagePaths.icon
                                    .toWidget(boxfit: BoxFit.fitWidth)))
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GridView(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  children: [
                    MenuCard(
                      onTap: () {
                        navigation.navigateToPage(
                            path: NavigationConstants.GENERATE_PASS_VIEW);
                      },
                      icon: Icon(
                        Icons.security_outlined,
                        size: iconSize,
                      ),
                      title: LocaleKeys.home_menu_1,
                    ),
                    MenuCard(
                      onTap: () {
                        navigation.navigateToPage(
                            path: NavigationConstants.ADD_NOTE_VIEW);
                      },
                      icon: Icon(
                        Icons.add_circle_outlined,
                        size: iconSize,
                      ),
                      title: LocaleKeys.home_menu_2,
                    ),
                    MenuCard(
                      onTap: () {
                        navigation.navigateToPage(
                            path: NavigationConstants.STRENGTH_PASSWORD_VIEW);
                      },
                      icon: Icon(
                        Icons.graphic_eq_outlined,
                        size: iconSize,
                      ),
                      title: LocaleKeys.home_menu_3,
                    ),
                    MenuCard(
                      onTap: () {
                        navigation.navigateToPage(
                            path: NavigationConstants.NOTES_VIEW);
                      },
                      icon: Icon(
                        Icons.notes_outlined,
                        size: iconSize,
                      ),
                      title: LocaleKeys.home_menu_4,
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
