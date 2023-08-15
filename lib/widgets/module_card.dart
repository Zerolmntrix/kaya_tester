import 'package:flutter/material.dart';

import '../models/module.dart';
import '../utils/constants.dart';
import 'card.dart';

class ModuleCard extends StatelessWidget {
  const ModuleCard(this.module, {super.key});

  final Module module;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MyCard(
      child: Column(
        children: [
          const SizedBox(height: 30),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.memory(
              module.icon,
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            module.info['name'] ?? 'Unknown',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Language',
                      style: textTheme.labelMedium,
                    ),
                    Text(
                      module.info['language'] ?? 'Unknown',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              Container(
                width: 3.0,
                height: 35.0,
                color: kTextColor,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Developer',
                      style: textTheme.labelMedium,
                    ),
                    Text(
                      module.info['developer'] ?? 'Unknown',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
