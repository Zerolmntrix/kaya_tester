import 'dart:async';

import 'package:flutter/material.dart';

import '../models/module.dart';
import '../utils/constants.dart';
import '../utils/show_msg.dart';
import '../widgets/file_card.dart';
import '../widgets/uploader.dart';
import 'tests.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double progress = 0.0;
  Module? module;

  bool canGo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400.0,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              if (module == null)
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Uploader(onUpload: setModule),
                      ),
                      const SizedBox(height: 20.0),
                      const Text('No module imported yet.'),
                    ],
                  ),
                )
              else
                FileCard(
                  module!,
                  progress: progress,
                  onRemove: removeModule,
                ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: canGo ? goToTests : null,
                style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
                child:
                    const Text('Next', style: TextStyle(color: kNeutralColor)),
              ),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }

  void setModule(Module module) {
    setState(() {
      this.module = module;
    });
    startLoading();
  }

  void removeModule() {
    setState(() {
      module = null;
      canGo = false;
    });
  }

  void goToTests() {
    if (module!.info.baseUrl.isEmpty) {
      showMessage(context, 'Base url not found in info.json');
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TestsScreen(module!),
      ),
    );
  }

  void startLoading() {
    setState(() {
      progress = 0.0;
      canGo = false;
    });
    Timer.periodic(const Duration(milliseconds: 2), (timer) {
      setState(() => progress += 0.01);
      if (progress >= 1) {
        timer.cancel();
        setState(() => canGo = true);
      }
    });
  }
}
