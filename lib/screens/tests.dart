import 'package:flutter/material.dart';
import 'package:kagayaku_modules/kagayaku_modules.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/module.dart';
import '../utils/constants.dart';
import '../utils/grid_result.dart';
import '../utils/show_msg.dart';
import '../widgets/card.dart';
import '../widgets/modal.dart';
import '../widgets/module_card.dart';
import '../widgets/settings.dart';
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
  void dispose() {
    _testManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final module = _testManager.module;

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
                    buildTitle('Basic tests'),
                    TestCard(
                      title: 'Spotlight',
                      test: module.getSpotlightNovels,
                    ),
                    TestCard(
                      title: 'Latest',
                      test: module.getLatestNovels,
                    ),
                    TestCard(
                      title: 'Popular',
                      test: module.getPopularNovels,
                    ),
                    buildTitle('Advanced tests'),
                    TestCard.advanced(
                      title: 'Search',
                      settings: const {'query': 'text'},
                      testAdvanced: (data) {
                        final query = data.firstWhere((e) => e.key == 'query');

                        return module.getNovelsBySearch(query.value);
                      },
                    ),
                    TestCard(
                      title: 'Novel details',
                      test: module.getSpotlightNovels,
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

  Column buildTitle(String title) {
    return Column(
      children: [
        const SizedBox(height: 4.0),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8.0),
        const Divider(),
      ],
    );
  }
}
