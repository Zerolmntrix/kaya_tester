part of '../screens/tests.dart';

class TestCard extends StatefulWidget {
  const TestCard({super.key, required this.title, required this.test})
      : settings = null,
        testAdvanced = null;

  const TestCard.advanced({
    super.key,
    required this.title,
    required this.testAdvanced,
    required this.settings,
  }) : test = null;

  final String title;
  final NovelFunction Function()? test;
  final NovelFunction Function(List<FormData> data)? testAdvanced;
  final Map<String, String>? settings;

  @override
  State<TestCard> createState() => _TestCardState();
}

class _TestCardState extends State<TestCard> {
  final List<NovelModel> novels = [];
  TestStatus status = TestStatus.notStarted;

  List<FormData> formValues = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _TestManager().addTest(this);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Icon statusIcon;
    bool hasResult = status == TestStatus.passed || status == TestStatus.failed;

    switch (status) {
      case TestStatus.passed:
        statusIcon = const Icon(Icons.check_circle, color: Colors.green);
        break;
      case TestStatus.failed:
        statusIcon = const Icon(Icons.cancel, color: Colors.red);
        break;
      default:
        statusIcon = const Icon(Icons.block, size: 0);
    }

    return MyCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              statusIcon,
              const SizedBox(width: 8.0),
              if (widget.settings != null) ...[
                IconButton(
                  onPressed: openSettings,
                  icon: const Icon(Icons.settings),
                ),
                const SizedBox(width: 8.0),
              ],
              IconButton(
                onPressed: hasResult ? showResult : null,
                icon: const Icon(Icons.remove_red_eye),
              ),
              const SizedBox(width: 8.0),
              status == TestStatus.running
                  ? const _Loading()
                  : _ActionButton(status: status, onPressed: start),
            ],
          ),
        ],
      ),
    );
  }

  start() async {
    TestResult isResultOK;

    if (widget.settings != null && formValues.isEmpty) {
      if (!await openSettings()) return;
    }

    setState(() => status = TestStatus.running);

    try {
      final novels = widget.testAdvanced != null
          ? await widget.testAdvanced!(formValues)
          : await widget.test!();

      setState(() => this.novels
        ..clear()
        ..addAll(novels));
    } catch (e) {
      debugPrint(e.toString());
    }

    printInfo('Checking ${novels.length} novels from "${widget.title}"...');
    isResultOK = isOk(novels, printWarnings: true);
    printInfo('Test from "${widget.title}" finished');

    if (isResultOK.success) {
      setState(() => status = TestStatus.passed);
    } else {
      setState(() => status = TestStatus.failed);
    }
  }

  showResult() {
    final double screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Modal(
          title: widget.title,
          content: buildGridResult(novels, screenWidth),
          result: isOk(novels),
        );
      },
    );
  }

  openSettings() async {
    late bool canTest;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Settings for "${widget.title}"'),
          content: Form(
            key: _formKey,
            child: SizedBox(
              width: 400.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.settings!.entries.map((entry) {
                  final initial = formValues
                      .firstWhere((e) => e.key == entry.key,
                          orElse: () => FormData(entry.key, ''))
                      .value;

                  return buildFormField(entry, initial, (key, value) {
                    formValues.add(FormData(key, value));
                  });
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                canTest = false;

                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;

                formValues.clear();

                _formKey.currentState!.save();

                canTest = true;

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    return canTest;
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.status, this.onPressed});

  final TestStatus status;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    PhosphorFlatIconData icon = status == TestStatus.notStarted
        ? PhosphorIcons.fill.play
        : PhosphorIcons.regular.arrowClockwise;

    return SizedBox(
      width: 24.0,
      height: 24.0,
      child: IconButton(
        onPressed: onPressed,
        padding: const EdgeInsets.all(0.0),
        icon: PhosphorIcon(icon, color: kTextColor),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 22.0,
      height: 22.0,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(kTextColor),
      ),
    );
  }
}
