import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/file_card.dart';
import '../widgets/uploader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double progress = 0.0;
  ModuleFile? module;

  Archive archive = Archive();
  bool canGo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: SizedBox(
              width: 400.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (module.isNull) ...[
                    Uploader(onUpload: pickCompactedModule),
                    const SizedBox(height: 20.0),
                    if (module.isNull) const Text('No module imported yet.'),
                  ],
                  if (module != null)
                    FileCard(
                      module!,
                      progress: progress,
                      onRemove: removeModule,
                    ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 400.0,
            child: ElevatedButton(
              onPressed: canGo ? () => goToTests() : null,
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
              child: const Text('Next', style: TextStyle(color: kNeutralColor)),
            ),
          ),
          const Spacer()
        ],
      ),
    );
  }

  void pickCompactedModule() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result == null) return;

    PlatformFile zipFile = result.files.first;

    setState(() => archive = ZipDecoder().decodeBytes(zipFile.bytes!));

    final module = getFile('module.kaya');
    final moduleInfo = getFile('info.json');
    final moduleIcon = getFile('icon.png');

    if (module == null || moduleInfo == null || moduleIcon == null) return;

    setState(() {
      this.module = ModuleFile(
        file: module,
        info: moduleInfo,
        icon: moduleIcon,
      );
    });
    startLoading();
  }

  void removeModule() {
    setState(() {
      module = null;
      canGo = false;
      archive = Archive();
    });
  }

  void goToTests() {
    final module = getFile('module.kaya');
    final moduleInfo = getFile('info.json');
    final moduleIcon = getFile('icon.png');

    if (module == null || moduleInfo == null || moduleIcon == null) return;
  }

  ArchiveFile? getFile(String file) {
    final moduleDir = archive.fileName(0);

    final module = archive.findFile('$moduleDir$file');
    if (module == null) showMessage(file);

    return module;
  }

  void showMessage(String file) {
    Flushbar(
      icon: const Icon(Icons.info_outline, size: 28.0, color: kPrimaryColor),
      maxWidth: 300,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      message: "File \"$file\" not found.",
      leftBarIndicatorColor: kPrimaryColor,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }

  void startLoading() {
    setState(() => progress = 0.0);
    Timer.periodic(const Duration(milliseconds: 20), (timer) {
      setState(() => progress += 0.01);
      if (progress >= 1) {
        timer.cancel();
        setState(() => canGo = true);
      }
    });
  }
}
