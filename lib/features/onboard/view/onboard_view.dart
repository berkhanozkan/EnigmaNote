import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/lang/locale_keys.g.dart';
import '../../../core/manage/navigation/navigation_service.dart';
import '../../../core/manage/shared_pref/shared_preferences.dart';
import '../../../tool/constants/navigation_constants.dart';
import '../../../tool/constants/system_constants.dart';
import '../cubit/onboard_cubit.dart';
import '../model/onboard_model.dart';
import '../page_indicator.dart';

class OnboardView extends StatelessWidget {
  final PageController pageController = PageController();
  NavigationService navigation = NavigationService.instance;
  ValueNotifier<bool> isBackButtonEnable = ValueNotifier(false);

  OnboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => OnboardCubit(OnBoardModels.onBoardPageItems)),
      ],
      child: BlocConsumer<OnboardCubit, OnboardState>(
        listener: (context, state) {},
        builder: (context, state) {
          return buildScaffold(context);
        },
      ),
    );
  }

  Widget buildScaffold(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const SystemPadding.all(),
        child: Column(children: [
          Expanded(
            flex: 70,
            child: _pageView(),
          ),
          Expanded(
            flex: 5,
            child: PageIndicator(
                selectedIndex: context.watch<OnboardCubit>().selectedPage),
          ),
          Expanded(
            flex: 6,
            child: Visibility(
              visible: context.watch<OnboardCubit>().isLastPage(),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      await SharedPrefs.setBool(
                          SharedPrefsKeys.isSeenOnBoard, true);
                      await navigation.navigateToPageRemovedUntil(
                          path: NavigationConstants.HOME_VIEW);
                    },
                    child: const Text(LocaleKeys.onboard_btn_title).tr()),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _pageView() {
    List<OnBoardModel> items = OnBoardModels.onBoardPageItems;
    return BlocConsumer<OnboardCubit, OnboardState>(
      listener: (context, state) {},
      builder: (context, state) {
        return PageView.builder(
          controller: pageController,
          onPageChanged: (value) {
            context.read<OnboardCubit>().pageIndexControl(value);
          },
          itemCount: items.length,
          itemBuilder: (context, index) {
            OnBoardModel item = items[index];
            return Padding(
              padding: const SystemPadding.all(),
              child: Column(
                children: [
                  Expanded(
                    flex: 50,
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Image.asset(
                          item.imgName,
                          fit: BoxFit.contain,
                        )),
                  ),
                  Expanded(
                    flex: 10,
                    child: FittedBox(
                      child: Text(
                        item.title.tr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 28,
                            fontStyle: FontStyle.normal),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Text(
                      item.description.tr(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
