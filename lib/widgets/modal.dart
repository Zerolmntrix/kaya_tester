import 'package:flutter/material.dart';

import '../utils/constants.dart';

class Modal extends StatelessWidget {
  const Modal(
      {super.key, required this.title, required this.content, this.leading});

  final String title;
  final Widget? leading;
  final GridView content;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: constraints.maxWidth * 0.8,
            height: constraints.maxHeight * 0.8,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: kNeutralColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        size: 30.0,
                        color: kSecondaryColor,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 24.0),
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 16.0),
                ],
                Expanded(child: content),
              ],
            ),
          ),
        );
      },
    );
  }
}
