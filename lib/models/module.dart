import 'package:archive/archive.dart';
import 'package:flutter/cupertino.dart';

import '../widgets/show_msg.dart';

class Module {
  Module(this.context, this.archive) {
    _file = _getFile('module.kaya');
    _info = _getFile('info.json');
    _icon = _getFile('icon.png');
  }

  ArchiveFile? _file;
  ArchiveFile? _info;
  ArchiveFile? _icon;

  Archive archive;
  BuildContext context;

  get file => _file;

  get info => _info;

  get icon => _icon;

  ArchiveFile? _getFile(String filename) {
    final moduleDir = archive.fileName(0);

    final file = archive.findFile('$moduleDir$filename');
    if (file == null) showMessage(context, 'File not found: "$filename"');

    return file;
  }

  bool isOk() => _file != null && _info != null && _icon != null;
}
