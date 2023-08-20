import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:kagayaku_modules/kagayaku_modules.dart';

class Module {
  Module(this._archive) {
    _file = _getFile('module.kaya');
    _info = _getFile('info.json');
    _icon = _info != null ? _getFile(info.icon) : null;
  }

  final Archive _archive;

  late final ArchiveFile? _file;
  late final ArchiveFile? _info;
  late final ArchiveFile? _icon;

  get file => _file?.content;

  get icon => _icon?.content;

  ModuleInfo get info {
    final encodedInfo = _info?.content;
    ModuleInfo moduleInfo = ModuleInfo.fromJson({});

    if (encodedInfo == null) return moduleInfo;

    try {
      final jsonString = utf8.decode(encodedInfo);
      moduleInfo = ModuleInfo.fromJson(json.decode(jsonString));
    } catch (e) {
      throw Exception('Error parsing module info: $e');
    }

    return moduleInfo;
  }

  ArchiveFile? _getFile(String filename) {
    final moduleDir = _archive.fileName(0);

    final file = _archive.findFile('$moduleDir$filename');
    if (file == null) throw Exception('"$filename" not found in module');

    return file;
  }

  bool isOk() => _file != null && _info != null && _icon != null;
}
