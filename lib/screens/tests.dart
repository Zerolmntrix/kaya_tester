import 'package:flutter/material.dart';
import 'package:kagayaku_modules/kagayaku_modules.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/module.dart';
import '../utils/constants.dart';
import '../widgets/card.dart';
import '../widgets/module_card.dart';

part '../utils/test_manager.dart';
part '../widgets/test_card.dart';

class TestsScreen extends StatefulWidget {
  const TestsScreen(this.module, {super.key});

  final Module module;

  @override
  State<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  final _TestManager _testManager = _TestManager();

  @override
  void initState() {
    super.initState();
    _testManager.setModule(widget.module);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    TestCard(
                      title: 'Spotlight',
                      test: _testManager.module.getSpotlightNovels,
                    ),
                    // const SizedBox(height: 16),
                    // TestCard(title: 'Latest', test: () {}),
                    // const SizedBox(height: 16),
                    // TestCard(title: 'Popular', test: () {}),
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
    for (final test in _testManager.tests) {
      test.start();
    }
  }
}

// appBar: AppBar(
//   actions: [
//     TextButton(
//       onPressed: () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomeScreen()),
//         );
//       },
//       child: const Text('Reimport'),

//     ),
//     const SizedBox(width: 20.0),
//     ElevatedButton(
//       onPressed: startAllTests,
//       child: const Text('Test All'),
//     ),
//     const SizedBox(width: 20.0),
//   ],
// ),
