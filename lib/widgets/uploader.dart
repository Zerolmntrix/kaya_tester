import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

import '../models/module.dart';
import '../utils/constants.dart';
import '../utils/show_msg.dart';

class Uploader extends StatefulWidget {
  const Uploader({super.key, required this.onUpload});

  final void Function(Module) onUpload;

  @override
  State<Uploader> createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  bool isHovering = false;
  FilePickerStatus status = FilePickerStatus.done;

  @override
  Widget build(BuildContext context) {
    return DropRegion(
      formats: Formats.standardFormats,
      hitTestBehavior: HitTestBehavior.opaque,
      onDropOver: (event) => DropOperation.copy,
      onDropEnter: (event) => setState(() => isHovering = true),
      onDropLeave: (event) => setState(() => isHovering = false),
      onPerformDrop: (event) async {
        final reader = event.session.items.first.dataReader!;

        if (!reader.canProvide(Formats.zip)) rejectFile();

        reader.getFile(Formats.zip, (file) async {
          final stream = file.getStream();

          acceptFile(await stream.toBytes());
        });
      },
      child: DottedBorder(
        borderType: BorderType.RRect,
        strokeWidth: 2.0,
        dashPattern: const [8, 4],
        radius: const Radius.circular(12),
        color: isHovering ? kPrimaryColor : kTextColor,
        child: InkWell(
          onTap: status == FilePickerStatus.done ? pickCompactedModule : null,
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
    );
  }

  void pickCompactedModule() async {
    setState(() => status = FilePickerStatus.picking);

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [kValidMime],
      dialogTitle: 'Select your module',
      lockParentWindow: true,
    );

    if (result == null) {
      setState(() => status = FilePickerStatus.done);
      return;
    }

    final PlatformFile zipFile = result.files.single;

    if (!zipFile.name.endsWith('.$kValidMime')) return rejectFile();

    if (kIsWeb) {
      return acceptFile(zipFile.bytes!);
    }

    Uint8List zipBytes = await File(zipFile.path!).readAsBytes();

    acceptFile(zipBytes);
  }

  void acceptFile(List<int> bytes) {
    setState(() => status = FilePickerStatus.done);

    final archive = ZipDecoder().decodeBytes(bytes);

    try {
      final module = Module(archive);
      if (!module.isOk()) throw Exception('Invalid module');

      showMessage(context, 'Module imported successfully!');

      widget.onUpload(module);
    } catch (e) {
      showMessage(
        context,
        e.toString().replaceFirst('Exception:', 'Error:'),
        isError: true,
      );
    }
  }

  void rejectFile() {
    showMessage(context, 'Only .zip files are allowed.');
  }
}

extension StreamBytes on Stream<Uint8List> {
  Future<Uint8List> toBytes() async {
    return await fold<Uint8List>(
      Uint8List(0),
      (Uint8List list, Uint8List data) => Uint8List.fromList(list + data),
    );
  }
}
