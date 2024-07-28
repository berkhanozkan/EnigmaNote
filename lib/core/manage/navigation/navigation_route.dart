import 'package:flutter/material.dart';

import '../../../features/home_view.dart';
import '../../../features/note/add_note_view.dart';
import '../../../features/note/my_notes_view.dart';
import '../../../features/note/note_detail_view.dart';
import '../../../features/onboard/view/onboard_view.dart';
import '../../../features/password/generate_password_view.dart';
import '../../../features/password/password_strenght_view.dart';
import '../../../model/note_model.dart';
import '../../../tool/constants/navigation_constants.dart';

class NavigationRoute {
  static final NavigationRoute _instance = NavigationRoute._init();
  static NavigationRoute get instance => _instance;
  NavigationRoute._init();

  Route<dynamic> onGenerateRoute(RouteSettings args) {
    switch (args.name) {
      case NavigationConstants.ONBOARD_VIEW:
        return normalNavigate(
          OnboardView(),
        );
      case NavigationConstants.HOME_VIEW:
        return normalNavigate(const HomeView());

      case NavigationConstants.ADD_NOTE_VIEW:
        return normalNavigate(const AddNoteView());

      case NavigationConstants.EDIT_NOTE_VIEW:
        return normalNavigate(NoteDetailView(
          note: args.arguments as NoteModel,
        ));

      case NavigationConstants.GENERATE_PASS_VIEW:
        return normalNavigate(const GeneratePasswordView());

      case NavigationConstants.NOTES_VIEW:
        return normalNavigate(const MyNotesView());

      case NavigationConstants.STRENGTH_PASSWORD_VIEW:
        return normalNavigate(const PasswordStrenghtView());

      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(body: Text('NotFound')),
        ); //TODO NOt found widget yap
    }
  }

  MaterialPageRoute normalNavigate(Widget widget) {
    return MaterialPageRoute(builder: (context) => widget);
  }
}
