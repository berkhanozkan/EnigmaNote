import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/lang/locale_keys.g.dart';
import '../../core/manage/hive/hive_manager.dart';
import '../../core/manage/hive/service_manager.dart';
import '../../core/manage/navigation/navigation_service.dart';
import '../../model/note_model.dart';
import '../../tool/constants/color_constants.dart';
import '../../tool/constants/system_constants.dart';
import '../../tool/widget/custom_snackbar.dart';
import 'cubit/note_cubit.dart';

class NoteDetailView extends StatefulWidget {
  final NoteModel note;

  const NoteDetailView({Key? key, required this.note}) : super(key: key);

  @override
  _NoteDetailViewState createState() => _NoteDetailViewState();
}

class _NoteDetailViewState extends State<NoteDetailView> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _passwordController = TextEditingController();
  late final bool isCheck;
  NavigationService navigation = NavigationService.instance;

  bool _isSecure = true;

  void _changeLoading() {
    setState(() {
      _isSecure = !_isSecure;
      widget.note.password = _passwordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    _noteController.text = widget.note.description!;
    _titleController.text = widget.note.title!;
    _passwordController.text = widget.note.password!;

    return BlocProvider(
      create: (context) => NoteCubit(NoteHiveManager()),
      child: buildScaffold(context),
    );
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text(LocaleKeys.note_detail_title).tr(),
        ),
        body: BlocConsumer<NoteCubit, NoteState>(
          listenWhen: (previous, current) {
            return previous != current;
          },
          builder: (context, state) {
            return Padding(
              padding: const SystemPadding.all(),
              child: SingleChildScrollView(
                child: Column(children: [
                  Padding(
                    padding: const SystemPadding.miniAll(),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      controller: _titleController,
                    ),
                  ),
                  Padding(
                    padding: const SystemPadding.miniAll(),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      minLines: 1,
                      maxLines: 8,
                      controller: _noteController,
                    ),
                  ),
                  Padding(
                    padding: const SystemPadding.onlyTop(),
                    child: Row(
                      children: [
                        Checkbox(
                            checkColor: SystemColor.colorWhite,
                            visualDensity: VisualDensity.compact,
                            value: widget.note.isEncrypt,
                            onChanged: (value) {
                              setState(() {
                                widget.note.isEncrypt = value;
                              });
                            }),
                        const Text(
                          LocaleKeys.add_note_check_encryption_title,
                          softWrap: true,
                        ).tr(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const SystemPadding.onlyTop(),
                    child: Visibility(
                      visible: widget.note.isEncrypt!,
                      child: TextFormField(
                        obscureText: _isSecure,
                        maxLength: 10,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.add_note_psw_title.tr(),
                          fillColor: SystemColor.black12,
                          suffix: _onVisibilityIcon(),
                          filled: true,
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const SystemPadding.onlyTop(),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                        onPressed: () async {
                          if (widget.note.isEncrypt == false) {
                            _passwordController.text = "";
                          }
                          context
                              .read<NoteCubit>()
                              .updateNote(NoteModel(
                                  title: _titleController.text,
                                  description: _noteController.text,
                                  isEncrypt: widget.note.isEncrypt,
                                  key: widget.note.key,
                                  password: _passwordController.text))
                              .then((value) {
                            if (value) {
                              CustomSnackBar.showPositive(
                                context,
                                LocaleKeys.note_detail_success_save.tr(),
                              );
                            } else {
                              CustomSnackBar.showNegative(
                                context,
                                LocaleKeys.note_detail_error_save.tr(),
                              );
                            }
                            FocusScope.of(context).unfocus();
                          });
                        },
                        child: Text(
                          LocaleKeys.note_detail_save_edit,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ).tr(),
                      ),
                    ),
                  )
                ]),
              ),
            );
          },
          listener: (context, state) {},
        ));
  }

  IconButton _onVisibilityIcon() {
    return IconButton(
      onPressed: _changeLoading,
      icon: AnimatedCrossFade(
          firstChild: const Icon(Icons.visibility_outlined),
          secondChild: const Icon(Icons.visibility_off_outlined),
          crossFadeState:
              _isSecure ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(seconds: 2)),
    );
    // icon: Icon(_isSecure ? Icons.visibility : Icons.visibility_off));
  }
}
