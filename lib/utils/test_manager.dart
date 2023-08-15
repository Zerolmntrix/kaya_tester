part of '../screens/tests.dart';

enum TestStatus { notStarted, running, passed, failed }

class _TestManager {
  static final _TestManager _instance = _TestManager._internal();

  factory _TestManager() => _instance;

  _TestManager._internal();

  late final KagayakuModule _module;
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
}

bool isOk(List<NovelModel> novels) {
  if (novels.isEmpty) throw Exception('Novels list is empty');

  for (final novel in novels) {
    isNovelNotEmpty(novel);
  }

  return true;
}

isSearchOk(List<NovelModel> novels, String search) {
  isOk(novels);
}

isNovelNotEmpty(NovelModel novel) {
  if (novel.title.isEmpty) {
    throw Exception('Novel title is empty');
  }

  if (novel.cover.isEmpty) {
    throw Exception('Novel cover is empty');
  }

  if (novel.url.isEmpty) {
    throw Exception('Novel url is empty');
  }
}
