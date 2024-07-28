import 'package:easy_localization/easy_localization.dart';
import 'core/manage/hive/service_manager.dart';
import 'model/note_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'core/manage/navigation/navigation_route.dart';
import 'core/manage/navigation/navigation_service.dart';
import 'core/manage/shared_pref/shared_preferences.dart';
import 'features/home_view.dart';
import 'features/note/cubit/note_cubit.dart';
import 'features/onboard/view/onboard_view.dart';
import 'tool/constants/color_constants.dart';
import 'tool/constants/system_constants.dart';

Future<void> main() async {
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await _init();

  final bool isSeenOnBoard = SharedPrefs.getBool(SharedPrefsKeys.isSeenOnBoard);

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('tr', 'TR'),
        Locale('en', 'US'),
      ],
      path: SystemConstants.TRANSLATIONS,
      fallbackLocale: const Locale('tr', 'TR'),
      child: BlocProvider(
        create: (context) => NoteCubit(ServiceManager.instance.service),
        child: MyApp(isSeenOnBoard: isSeenOnBoard),
      ),
    ),
  );
  Future.delayed(const Duration(seconds: 2)).then((value) {
    FlutterNativeSplash.remove();
  });
}

Future<void> _init() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteModelAdapter());
  await Hive.openBox<NoteModel>("notesCache");
  await SharedPrefs.init();
  await EasyLocalization.ensureInitialized();
}

class MyApp extends StatelessWidget {
  final bool isSeenOnBoard;
  const MyApp({super.key, required this.isSeenOnBoard});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'OpenSans'),
        primaryTextTheme:
            ThemeData.dark().textTheme.apply(fontFamily: 'OpenSans'),
        sliderTheme: SliderThemeData(
            thumbColor: SystemColor.colorRedMain,
            activeTrackColor: SystemColor.colorRedMain,
            activeTickMarkColor: SystemColor.colorRedMain),
        checkboxTheme: CheckboxThemeData(
            checkColor: MaterialStateProperty.all(SystemColor.colorRedMain),
            fillColor: MaterialStateProperty.all(SystemColor.colorRedMain)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(SystemColor.colorRedMain),
          ),
        ),
      ),
      title: SystemConstants.APP_TITLE,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      navigatorKey: NavigationService.instance.navigatorKey,
      onGenerateRoute: NavigationRoute.instance.onGenerateRoute,
      home: isSeenOnBoard ? const HomeView() : OnboardView(),
    );
  }
}
