import 'package:flutter/material.dart';
import 'package:kagayaku_modules/kagayaku_modules.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/module.dart';
import '../utils/constants.dart';
import '../utils/grid_result.dart';
import '../widgets/card.dart';
import '../widgets/modal.dart';
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
                    ModuleCard(widget.module, controls: buidControls),
                    const SizedBox(height: 20),
                    TestCard(
                      title: 'Spotlight',
                      test: _testManager.module.getSpotlightNovels,
                    ),
                    const SizedBox(height: 16),
                    TestCard(
                      title: 'Latest',
                      test: _testManager.module.getLatestNovels,
                    ),
                    const SizedBox(height: 16),
                    TestCard(
                      title: 'Popular',
                      test: _testManager.module.getPopularNovels,
                    ),
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

  void goToImport() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  Row buidControls() {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    );

    const double fontSize = 16.0;
    const FontWeight fontWeight = FontWeight.w500;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: goToImport,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: shape,
            ),
            child: const Text(
              'Import another module',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: ElevatedButton(
            onPressed: startAllTests,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              shape: shape,
            ),
            child: const Text(
              'Execute all tests',
              style: TextStyle(
                color: kNeutralColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
