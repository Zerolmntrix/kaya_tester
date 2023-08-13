import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../constants.dart';

class FileCard extends StatelessWidget {
  const FileCard(
    this.module, {
    super.key,
    required this.progress,
    required this.onRemove,
  });

  final ModuleFile module;
  final double progress;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final progressString = (progress * 100).toStringAsFixed(0);
    final moduleIcon = module.icon.content as Uint8List;
    final moduleFile = module.file.content as Uint8List;
    final moduleInfo = module.info.content as Uint8List;

    final jsonString = utf8.decode(moduleInfo);
    final moduleData = json.decode(jsonString) as Map<String, dynamic>;

    return Container(
      height: 72.0,
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: kAccentColor,
            spreadRadius: 0,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Row(
        children: [
          Container(
            width: 56.0,
            height: 56.0,
            decoration: BoxDecoration(
              color: kNeutralColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Image.memory(
              moduleIcon,
              errorBuilder: (BuildContext ctx, Object ex, StackTrace? _) {
                return const Icon(Icons.file_copy, color: kSecondaryColor);
              },
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  moduleData['developer'] ?? 'Unknown developer',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  moduleData['baseUrl'] ?? 'Unknown url',
                  style: const TextStyle(
                    color: kTextColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999.0),
                    child: LinearProgressIndicator(
                      minHeight: 8.0,
                      color: kPrimaryColor,
                      value: progress,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 24.0,
                width: 24.0,
                child: IconButton(
                  onPressed: onRemove,
                  padding: const EdgeInsets.all(0.0),
                  color: kSecondaryColor,
                  icon: PhosphorIcon(PhosphorIcons.regular.x, size: 18.0),
                ),
              ),
              Text(
                '$progressString%',
                style: const TextStyle(
                  color: kTextColor,
                  height: 0.80,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ModuleFile {
  ModuleFile({
    required this.file,
    required this.info,
    required this.icon,
  });

  final ArchiveFile file;
  final ArchiveFile info;
  final ArchiveFile icon;
}
