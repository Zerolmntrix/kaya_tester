part of '../screens/tests.dart';

enum TestStatus { notStarted, running, passed, failed }

class TestResult {
  TestResult(this.success, [this.message]);

  final bool success;
  final String? message;
}

class _TestManager {
  static final _TestManager _instance = _TestManager._internal();

  factory _TestManager() => _instance;

  _TestManager._internal();

  late KagayakuModule _module;
  final List<_TestCardState> _testCardStates = [];

  List<_TestCardState> get tests => _testCardStates;

  KagayakuModule get module => _module;

  void addTest(_TestCardState testCardState) {
    _testCardStates.add(testCardState);
  }

  void setModule(Module moduleData) async {
    List<String> lines = String.fromCharCodes(moduleData.file).split('\n');

    final source = lines
        .where((line) => line.isNotEmpty)
        .where((line) => !line.startsWith('//'))
        .map((e) => e.trim())
        .toList();

    _module = KagayakuModule(source, moduleData.info.baseUrl);
  }

  void dispose() {
    _testCardStates.clear();
  }
}

TestResult isOk(List<NovelModel> novels, {bool printWarnings = false}) {
  String? message;

  if (novels.isEmpty) return TestResult(false, 'Novels list is empty');

  for (final novel in novels) {
    final List<String> msgs = isNovelNotEmpty(novel);

    if (msgs.isEmpty) continue;
    message = 'Novel "${novel.title}" has missing data';

    if (!printWarnings) continue;

    printWarning(message);

    for (final msg in msgs) {
      printError(msg);
    }
  }

  return TestResult(true, message);
}

TestResult isSearchOk(List<NovelModel> novels, String search) {
  return isOk(novels);
}

List<String> isNovelNotEmpty(NovelModel novel) {
  final List<String> msgs = [];

  if (novel.title.isEmpty) msgs.add('Title is empty');

  if (novel.cover.isEmpty) msgs.add('Cover is empty');

  if (novel.url.isEmpty) msgs.add('Url is empty');

  return msgs;
}
