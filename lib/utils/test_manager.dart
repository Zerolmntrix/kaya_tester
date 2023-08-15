part of '../screens/tests.dart';

enum TestStatus { notStarted, running, passed, failed }

class _TestManager {
  static final _TestManager _instance = _TestManager._internal();

  factory _TestManager() => _instance;

  _TestManager._internal();

  final List<_TestCardState> testCardStates = [];
}
