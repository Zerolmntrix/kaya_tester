import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../constants.dart';

class Uploader extends StatelessWidget {
  const Uploader({super.key, required this.onUpload});

  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      dashPattern: const [8, 4],
      radius: const Radius.circular(12),
      color: kSecondaryColor,
      child: InkWell(
        onTap: onUpload,
        child: Container(
          width: 400.0,
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: kNeutralColor,
          ),
          child: Column(
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
    );
  }
}
