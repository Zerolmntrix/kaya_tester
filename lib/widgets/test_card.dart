part of '../screens/tests.dart';

class TestCard extends StatefulWidget {
  const TestCard({super.key, required this.title, required this.test});

  final String title;
  final NovelFunction Function() test;

  @override
  State<TestCard> createState() => _TestCardState();
}

class _TestCardState extends State<TestCard> {
  TestStatus testStatus = TestStatus.notStarted;

  @override
  void initState() {
    super.initState();
    _TestManager().addTest(this);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Icon statusIcon;

    switch (testStatus) {
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
              if (testStatus == TestStatus.passed)
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.remove_red_eye),
                ),
              const SizedBox(width: 8.0),
              statusIcon,
              const SizedBox(width: 8.0),
              testStatus == TestStatus.running
                  ? const _Loading()
                  : _ActionButton(status: testStatus, onPressed: start),
            ],
          ),
        ],
      ),
    );
  }

  start() async {
    setState(() => testStatus = TestStatus.running);

    final resultIsOK = isOk(await widget.test());

    if (resultIsOK) {
      setState(() => testStatus = TestStatus.passed);
    } else {
      setState(() => testStatus = TestStatus.failed);
    }
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
