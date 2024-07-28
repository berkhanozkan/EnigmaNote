import 'package:easy_localization/easy_localization.dart';
import '../../core/manage/hive/hive_manager.dart';
import '../../tool/extensions/app_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../core/lang/locale_keys.g.dart';
import '../../core/manage/hive/service_manager.dart';
import '../../core/manage/navigation/navigation_service.dart';
import '../../model/note_model.dart';
import '../../tool/constants/color_constants.dart';
import '../../tool/constants/navigation_constants.dart';
import '../../tool/constants/system_constants.dart';
import '../../tool/function/custom_dialog.dart';
import '../../tool/widget/custom_snackbar.dart';
import 'cubit/note_cubit.dart';

class MyNotesView extends StatefulWidget {
  const MyNotesView({Key? key}) : super(key: key);

  @override
  _MyNotesViewState createState() => _MyNotesViewState();
}

class _MyNotesViewState extends State<MyNotesView> {
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<NoteModel> noteList;
    return BlocProvider(
      create: (context) =>
          NoteCubit(ServiceManager.instance.service)..getNotes(),
      child: BlocConsumer<NoteCubit, NoteState>(
        listenWhen: (previous, current) {
          return previous != current;
        },
        listener: (context, state) {
          if (state is NoteGetState) {
            noteList = state.noteList!;
          }
        },
        builder: (context, state) {
          if (state is NoteLoadingState) {
            return const Scaffold(
              body: Center(
                child: SizedBox(height: 50, child: CircularProgressIndicator()),
              ),
            );
          } else if (state is NoteGetState) {
            return RefreshIndicator(
              color: SystemColor.colorRedMain,
              onRefresh: () async {
                context.read<NoteCubit>().getNotes();
              },
              child: buildScaffold(state, context),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Scaffold buildScaffold(NoteGetState state, BuildContext context) {
    NavigationService navigation = NavigationService.instance;
    List<NoteModel>? items = state.noteList ?? [];
    return Scaffold(
      appBar: AppBar(
        title: const Text(LocaleKeys.my_notes_title).tr(),
      ),
      body: items.isNotEmpty
          ? Padding(
              padding: const SystemPadding.miniAll(),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, listIndex) {
                  NoteModel note = items[listIndex];
                  return Padding(
                    padding: const SystemPadding.miniAll(),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const SystemPadding.onlyVerticalSymmetric(),
                        child: ListTile(
                          leading: (note.isEncrypt ?? false)
                              ? Icon(Icons.lock_outlined,
                                  color: SystemColor.colorGreenShade300)
                              : Icon(
                                  Icons.lock_open_outlined,
                                  color: SystemColor.colorWhite,
                                ),
                          onTap: () {
                            (note.isEncrypt ?? false)
                                ? pswDialog(context, note, navigation)
                                : navigation
                                    .navigateToPage(
                                        path:
                                            NavigationConstants.EDIT_NOTE_VIEW,
                                        object: note)
                                    .then((value) =>
                                        context.read<NoteCubit>().getNotes());
                          },
                          title: Text(note.title!,
                              style: Theme.of(context).textTheme.titleLarge),
                          subtitle: RichText(
                            text: TextSpan(
                              text: (note.isEncrypt ?? false)
                                  ? "*" * note.description!.length
                                  : note.description,
                              style: Theme.of(context).textTheme.bodySmall!,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            onPressed: () => removeNoteDialog(context, note),
                            icon: Icon(
                              Icons.delete_outlined,
                              color: SystemColor.colorRedMain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(LottiePaths.empty.path(), height: 200),
                  Text(
                    LocaleKeys.my_notes_no_notes,
                    style: Theme.of(context).textTheme.titleSmall,
                  ).tr(),
                ],
              ),
            ),
    );
  }

  void removeNoteDialog(BuildContext context, NoteModel note) {
    showCustomDialog(
      context: context,
      title: null,
      widget: const Text(LocaleKeys.my_notes_warning_delete).tr(),
      onPressedOk: () async {
        await onPressedOk(context, note)
            .then((value) => Navigator.pop(context));
      },
      onPressedCancel: () => Navigator.pop(context),
    );
  }

  Future<void> onPressedOk(BuildContext context, NoteModel note) async {
    await context.read<NoteCubit>().removeNote(note.key!).then((value) {
      if (value) {
        CustomSnackBar.showPositive(
            context, LocaleKeys.my_notes_success_delete.tr());
      } else {
        CustomSnackBar.showNegative(
            context, LocaleKeys.my_notes_error_delete.tr());
      }
    }).whenComplete(() {
      return context.read<NoteCubit>().getNotes();
    });
  }

  void pswDialog(
      BuildContext context, NoteModel note, NavigationService navigation) {
    return showCustomDialog(
      context: context,
      title: const Text(LocaleKeys.my_notes_enter_password).tr(),
      widget: TextField(
        obscureText: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        controller: _passwordController,
      ),
      onPressedCancel: () {
        Navigator.pop(context);
        _passwordController.clear();
      },
      onPressedOk: () {
        note.password == _passwordController.text
            ? navigation
                .navigateToPushReplacement(
                    path: NavigationConstants.EDIT_NOTE_VIEW, object: note)
                .whenComplete(() {
                setState(() {
                  _passwordController.clear();
                });
              }).then((value) => context.read<NoteCubit>().getNotes())
            : null;
      },
    );
  }
}
