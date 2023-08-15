import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:flutter/cupertino.dart';

import '../widgets/show_msg.dart';

class Module {
  Module(this._context, this._archive) {
    _file = _getFile('module.kaya');
    _info = _getFile('info.json');
    _icon = _getFile(info['icon']);
  }

  final Archive _archive;
  final BuildContext _context;

  late final ArchiveFile? _file;
  late final ArchiveFile? _info;
  late final ArchiveFile? _icon;

  get file => _file?.content;

  get icon => _icon?.content;

  Map<String, dynamic> get info {
    final moduleInfoEncoded = _info?.content;

    if (moduleInfoEncoded == null) return {};

    final jsonString = utf8.decode(moduleInfoEncoded);

    return json.decode(jsonString);
  }

  ArchiveFile? _getFile(String filename) {
    final moduleDir = _archive.fileName(0);

    final file = _archive.findFile('$moduleDir$filename');
    if (file == null) showMessage(_context, 'File not found: "$filename"');

    return file;
  }

  bool isOk() => _file != null && _info != null && _icon != null;
}
