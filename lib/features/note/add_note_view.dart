import 'package:easy_localization/easy_localization.dart';
import '../../core/manage/hive/hive_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../core/lang/locale_keys.g.dart';
import '../../model/note_model.dart';
import '../../tool/constants/color_constants.dart';
import '../../tool/constants/system_constants.dart';
import '../../tool/widget/custom_snackbar.dart';
import 'cubit/note_cubit.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({Key? key}) : super(key: key);

  @override
  _AddNoteViewState createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isCheckedEncryption = false;
  final _formKey = GlobalKey<FormState>();

  bool _isSecure = true;

  void _changeLoading() {
    setState(() {
      _isSecure = !_isSecure;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => NoteCubit(NoteHiveManager()),
        child: buildScaffold(context));
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text(LocaleKeys.add_note_title).tr(),
        ),
        body: BlocConsumer<NoteCubit, NoteState>(
          listenWhen: (previous, current) {
            return previous != current;
          },
          builder: (context, state) {
            return Padding(
              padding: const SystemPadding.all(),
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const SystemPadding.onlyTop(),
                          child: TextFormField(
                            controller: _titleController, // :: title
                            decoration: InputDecoration(
                              labelText: LocaleKeys.add_note_note_title.tr(),
                              fillColor: SystemColor.black12,
                              filled: true, // dont forget this line
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const SystemPadding.onlyTop(),
                          child: TextFormField(
                            controller: _noteController,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 8,
                            decoration: InputDecoration(
                              labelText: LocaleKeys.add_note_description.tr(),
                              fillColor: SystemColor.black12,
                              filled: true,
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const SystemPadding.onlyTop(),
                          child: Row(
                            children: [
                              Checkbox(
                                  checkColor: SystemColor.colorWhite,
                                  visualDensity: VisualDensity.compact,
                                  value: isCheckedEncryption,
                                  onChanged: (value) {
                                    setState(() {
                                      isCheckedEncryption =
                                          !isCheckedEncryption;
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
                            visible: isCheckedEncryption,
                            child: TextFormField(
                              obscureText: _isSecure,
                              maxLength: 10,
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: LocaleKeys.add_note_psw_title.tr(),
                                fillColor: SystemColor.black12,
                                filled: true,
                                suffix: _onVisibilityIcon(),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 1.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ))),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  context
                                      .read<NoteCubit>()
                                      .saveNote(
                                        NoteModel(
                                            key: const Uuid().v1(),
                                            title: _titleController.text,
                                            description: _noteController.text,
                                            isEncrypt: isCheckedEncryption,
                                            password: _passwordController.text),
                                      )
                                      .then((value) {
                                    if (value) {
                                      CustomSnackBar.showPositive(
                                          context,
                                          LocaleKeys.add_note_success_save
                                              .tr());
                                      _setEmptyFields();
                                    } else {
                                      CustomSnackBar.showNegative(context,
                                          LocaleKeys.add_note_error_save.tr());
                                    }
                                  });

                                  _setEmptyFields();
                                }
                              },
                              child: Text(
                                context.watch<NoteCubit>().isLoading
                                    ? LocaleKeys.add_note_please_wait
                                    : LocaleKeys.add_note_btn_add,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ).tr(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            );
          },
          listener: (context, state) {},
        ));
  }

  void _setEmptyFields() {
    setState(() {
      FocusScope.of(context).unfocus();
      _formKey.currentState!.reset();
      _noteController.clear();
      _passwordController.clear();
      _titleController.clear();
      isCheckedEncryption = false;
    });
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
