import 'package:flutter/material.dart';

import '../screens/tests.dart';
import '../utils/constants.dart';

class Modal extends StatelessWidget {
  const Modal({
    super.key,
    required this.title,
    required this.content,
    this.leading,
    required this.result,
  });

  final String title;
  final Widget? leading;
  final GridView content;
  final TestResult result;

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
                  const SizedBox(height: 16.0),
                ],
                if (result.success && result.message != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Text(
                      'The are some data missing. Please check the console.',
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
                if (result.success)
                  Expanded(child: content)
                else ...[
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: kPrimaryColor,
                            size: 120,
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            result.message!,
                            style: textTheme.headlineSmall?.copyWith(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Open the browser console for more details.',
                            style: textTheme.labelSmall?.copyWith(
                              color: kTextColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
