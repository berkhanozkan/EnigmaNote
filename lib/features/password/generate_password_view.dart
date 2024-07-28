import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/lang/locale_keys.g.dart';
import '../../tool/constants/color_constants.dart';
import '../../tool/constants/system_constants.dart';
import '../../tool/function/generate_password.dart';

class GeneratePasswordView extends StatefulWidget {
  const GeneratePasswordView({Key? key}) : super(key: key);

  @override
  State<GeneratePasswordView> createState() => _GeneratePasswordViewState();
}

class _GeneratePasswordViewState extends State<GeneratePasswordView> {
  final _controller = TextEditingController();
  double currentSliderValue = 5;
  bool isCheckedLetter = false;
  bool isCheckedNumber = false;
  bool isCheckedSpecial = false;
  Future<void> _generate() async {
    _controller.text = await generatePassword(
        length: currentSliderValue.toInt(),
        letter: isCheckedLetter,
        isNumber: isCheckedNumber,
        isSpecial: isCheckedSpecial);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(LocaleKeys.password_generator_generate_password).tr(),
      ),
      body: Padding(
        padding: const SystemPadding.all(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              controller: _controller,
              enableInteractiveSelection: false,
              readOnly: true,
              decoration: InputDecoration(
                fillColor: SystemColor.black12,
                filled: true, // dont forget this line
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                suffixIcon: IconButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      final data = ClipboardData(text: _controller.text);
                      Clipboard.setData(data);
                      final snackbar = SnackBar(
                          content: const Text(
                        LocaleKeys.password_generator_copy_pass,
                      ).tr());
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(snackbar);
                    }
                  },
                  icon: Icon(
                    Icons.copy_all_outlined,
                    color: SystemColor.colorWhite,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const SystemPadding.onlyTop(),
              child: Text(
                LocaleKeys.password_generator_content,
                style: Theme.of(context).textTheme.titleLarge,
              ).tr(),
            ),
            const Divider(),
            Row(
              children: [
                Checkbox(
                    checkColor: SystemColor.colorWhite,
                    visualDensity: VisualDensity.compact,
                    value: isCheckedLetter,
                    onChanged: (value) {
                      setState(() {
                        isCheckedLetter = !isCheckedLetter;
                      });
                    }),
                const Text(
                  LocaleKeys.password_generator_letter,
                  softWrap: true,
                ).tr(),
              ],
            ),
            Row(
              children: [
                Checkbox(
                    checkColor: SystemColor.colorWhite,
                    visualDensity: VisualDensity.compact,
                    value: isCheckedNumber,
                    onChanged: (value) {
                      setState(() {
                        isCheckedNumber = !isCheckedNumber;
                      });
                    }),
                const Text(
                  LocaleKeys.password_generator_number,
                  softWrap: true,
                ).tr(),
              ],
            ),
            Row(
              children: [
                Checkbox(
                    checkColor: SystemColor.colorWhite,
                    visualDensity: VisualDensity.compact,
                    value: isCheckedSpecial,
                    onChanged: (value) {
                      setState(() {
                        isCheckedSpecial = !isCheckedSpecial;
                      });
                    }),
                const Text(
                  LocaleKeys.password_generator_special_character,
                  softWrap: true,
                ).tr(),
              ],
            ),
            Padding(
              padding: const SystemPadding.onlyTop(),
              child: Text(
                LocaleKeys.password_generator_length,
                style: Theme.of(context).textTheme.titleLarge,
              ).tr(),
            ),
            const Divider(),
            Slider(
              value: currentSliderValue,
              max: 15,
              min: 5,
              divisions: 10,
              label: currentSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  currentSliderValue = value;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ))),
                onPressed: (isCheckedLetter == false &&
                        isCheckedNumber == false &&
                        isCheckedSpecial == false)
                    ? null
                    : () {
                        _generate();
                      },
                child: Text(
                  LocaleKeys.password_generator_generate_password,
                  style: Theme.of(context).textTheme.bodyLarge,
                ).tr(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
