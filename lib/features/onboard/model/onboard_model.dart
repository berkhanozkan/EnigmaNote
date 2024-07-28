import '../../../core/lang/locale_keys.g.dart';
import '../../../tool/extensions/app_extensions.dart';

class OnBoardModel {
  final String title;
  final String description;
  final String imgName;

  OnBoardModel(this.title, this.description, this.imgName);
}

class OnBoardModels {
  static final List<OnBoardModel> onBoardPageItems = [
    OnBoardModel(
      LocaleKeys.onboard_first_title,
      LocaleKeys.onboard_first_description,
      ImagePaths.onboard_first.path(),
    ),
    OnBoardModel(
      LocaleKeys.onboard_second_title,
      LocaleKeys.onboard_second_description,
      ImagePaths.onboard_second.path(),
    ),
    OnBoardModel(
      LocaleKeys.onboard_third_title,
      LocaleKeys.onboard_third_description,
      ImagePaths.onboard_third.path(),
    ),
    OnBoardModel(
      LocaleKeys.onboard_fourth_title,
      LocaleKeys.onboard_fourth_description,
      ImagePaths.onboard_fourth.path(),
    )
  ];
}
