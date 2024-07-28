import 'package:flutter/material.dart';

enum ImagePaths {
  onboard_first,
  onboard_second,
  onboard_third,
  onboard_fourth,
  onboard_fifth,
  bg,
  en_flag,
  icon,
  logo,
  tr_flag
}

extension ImagePathsExtension on ImagePaths {
  String path() {
    return 'assets/images/$name.png';
  }

  Widget toWidget({BoxFit? boxfit}) {
    return Image.asset(
      path(),
      fit: boxfit,
      // height: height,
    );
  }
}

enum LottiePaths { empty }

extension LottiePathExtension on LottiePaths {
  String path() {
    return 'assets/lotties/$name.json';
  }
}
