import 'package:archive/archive.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/module.dart';
import '../utils/constants.dart';
import 'show_msg.dart';

class Uploader extends StatefulWidget {
  const Uploader({super.key, required this.onUpload});

  final void Function(Module) onUpload;

  @override
  State<Uploader> createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  late DropzoneViewController controller;

  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DropzoneView(
          mime: kValidMime,
          onDrop: acceptFile,
          onDropInvalid: rejectFile,
          onCreated: (ctrl) => controller = ctrl,
          onHover: () => setState(() => isHovering = true),
          onLeave: () => setState(() => isHovering = false),
        ),
        DottedBorder(
          borderType: BorderType.RRect,
          dashPattern: const [8, 4],
          radius: const Radius.circular(12),
          color: isHovering ? kPrimaryColor : kTextColor,
          child: InkWell(
            onTap: pickCompactedModule,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: kNeutralColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PhosphorIcon(
                    PhosphorIcons.regular.cloudArrowUp,
                    size: 64.0,
                    color: kPrimaryColor,
                  ),
                  const Text(
                    'Import your module',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Drag and drop here or click to upload.',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: kTextColor,
                    ),
                  ),
                  const Text(
                    'Only .zip files are allowed.',
                    style: TextStyle(
                      fontSize: 10.0,
                      color: kTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void pickCompactedModule() async {
    final result = await controller.pickFiles(mime: kValidMime);

    final zipFile = result.first;

    if (!zipFile.name.endsWith('.zip')) return rejectFile(zipFile);

    acceptFile(zipFile);
  }

  void acceptFile(dynamic event) async {
    final data = await controller.getFileData(event);

    final archive = ZipDecoder().decodeBytes(data);

    if (context.mounted) {
      final module = Module(context, archive);
      if (!module.isOk()) return;

      widget.onUpload(module);
    }
  }

  void rejectFile(dynamic _) async {
    showMessage(context, 'Only .zip files are allowed.');
  }
}
