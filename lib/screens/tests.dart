import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/module.dart';
import '../utils/constants.dart';
import '../widgets/card.dart';
import '../widgets/module_card.dart';
import 'home.dart';

part '../utils/test_manager.dart';
part '../widgets/test_card.dart';

class TestsScreen extends StatefulWidget {
  const TestsScreen(this.module, {super.key});

  final Module module;

  @override
  State<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 20.0),
          ElevatedButton(
            onPressed: startAllTests,
            child: const Text('Test All'),
          ),
          const SizedBox(width: 20.0),
        ],
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(10.0),
          children: [
            Center(
              child: SizedBox(
                width: 550.0,
                child: Column(
                  children: [
                    ModuleCard(widget.module),
                    const SizedBox(height: 20),
                    const TestCard(title: 'Spotlight'),
                    const SizedBox(height: 12),
                    const TestCard(title: 'Latest'),
                    const TestCard(title: 'Popular'),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void startAllTests() {
    for (final testCardState in _TestManager().testCardStates) {
      testCardState.startTest();
    }
  }
}
