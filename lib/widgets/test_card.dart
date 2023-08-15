part of '../screens/tests.dart';

class TestCard extends StatefulWidget {
  const TestCard({super.key, required this.title, required this.test});

  final String title;
  final NovelFunction Function() test;

  @override
  State<TestCard> createState() => _TestCardState();
}

class _TestCardState extends State<TestCard> {
  final List<NovelModel> novels = [];
  TestStatus status = TestStatus.notStarted;

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
              IconButton(
                onPressed: hasResult ? showResult : null,
                icon: const Icon(Icons.remove_red_eye),
              ),
              const SizedBox(width: 8.0),
              statusIcon,
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
    setState(() => status = TestStatus.running);

    final novels = await widget.test();

    setState(() => this.novels.addAll(novels));

    final resultIsOK = isOk(await widget.test());

    if (resultIsOK) {
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
        );
      },
    );
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
