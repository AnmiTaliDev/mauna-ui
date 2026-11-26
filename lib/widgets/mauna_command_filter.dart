import 'mauna_popup.dart';

List<MaunaCommand> filterCommands(List<MaunaCommand> commands, String query) {
  final String needle = query.toLowerCase();
  final List<List<MaunaCommand>> ranks = <List<MaunaCommand>>[
    for (int i = 0; i < _rankCount; i++) <MaunaCommand>[],
  ];
  for (final MaunaCommand command in commands) {
    final int? rank = _rank(command.label.toLowerCase(), needle);
    if (rank != null) {
      ranks[rank].add(command);
    }
  }
  return <MaunaCommand>[for (final List<MaunaCommand> rank in ranks) ...rank];
}

const int _rankCount = 4;

int? _rank(String label, String needle) {
  if (label.startsWith(needle)) {
    return 0;
  }
  if (label.contains(' $needle')) {
    return 1;
  }
  if (label.contains(needle)) {
    return 2;
  }
  return _holdsInOrder(label, needle) ? 3 : null;
}

bool _holdsInOrder(String label, String needle) {
  int from = 0;
  for (int i = 0; i < needle.length; i++) {
    if (needle[i] == ' ') {
      continue;
    }
    final int found = label.indexOf(needle[i], from);
    if (found < 0) {
      return false;
    }
    from = found + 1;
  }
  return true;
}
