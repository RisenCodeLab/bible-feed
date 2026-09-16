// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:io';

import 'package:path/path.dart' as p;

const _packageName = 'bible_feed';
const _libDir = 'lib';
const _ignoreSuffixes = <String>['.config.dart', '.injectable.dart', '.mapper.dart'];
final _libDirPath = Directory(_libDir).absolute.path;

final _importExportRegExp = RegExp(r'''^\s*(import|export)\s+(['"])([^'"]+)\2(\s*.*)''');

bool _shouldIgnore(String relativePath) {
  if (relativePath.contains('injectable')) {
    return true;
  }
  for (final suffix in _ignoreSuffixes) {
    if (relativePath.endsWith(suffix)) {
      return true;
    }
  }
  return false;
}

bool _isPackageBibleFeed(String path) => path.startsWith('package:$_packageName/');

String _toRelative(String importerPath, String target) {
  final subpath = target.substring('package:$_packageName/'.length);
  final importerDir = p.dirname(importerPath);
  final targetPath = p.join(_libDirPath, subpath);
  var relative = p.relative(targetPath, from: importerDir);
  relative = relative.replaceAll('\\', '/');
  return relative.startsWith('.') ? relative : './$relative';
}

int _groupKey(String path) {
  if (path.startsWith('dart:')) {
    return 0;
  }
  if (path.startsWith('package:')) {
    return 1;
  }
  return 2;
}

class _ImportEntry {
  _ImportEntry(this.kind, this.quote, this.path, this.suffix);

  final String kind;
  final String quote;
  final String path;
  final String suffix;
}

List<String> _organise(List<_ImportEntry> entries) {
  final buckets = {0: <_ImportEntry>[], 1: <_ImportEntry>[], 2: <_ImportEntry>[]};
  for (final entry in entries) {
    buckets[_groupKey(entry.path)]?.add(entry);
  }
  final List<String> lines = [];
  var firstGroup = true;
  for (var index = 0; index <= 2; index++) {
    final bucket = buckets[index]!;
    if (bucket.isEmpty) {
      continue;
    }
    bucket.sort((a, b) {
      final pathCmp = a.path.compareTo(b.path);
      return pathCmp != 0 ? pathCmp : a.kind.compareTo(b.kind);
    });
    if (!firstGroup) {
      lines.add('');
    }
    firstGroup = false;
    for (final entry in bucket) {
      lines.add("${entry.kind} ${entry.quote}${entry.path}${entry.quote}${entry.suffix}");
    }
  }
  return lines;
}

bool _processFile(File file) {
  final relativePath = p.relative(file.path, from: _libDir);
  if (_shouldIgnore(relativePath)) {
    return false;
  }
  final content = file.readAsStringSync();
  final hadTrailingNewline = content.endsWith('\n');
  final lines = content.split('\n');
  final entries = <Map<String, dynamic>>[];
  for (var i = 0; i < lines.length; i++) {
    final match = _importExportRegExp.firstMatch(lines[i]);
    if (match == null) {
      continue;
    }
    entries.add({'index': i, 'kind': match.group(1)!, 'quote': match.group(2)!, 'path': match.group(3)!, 'suffix': match.group(4)!});
  }
  if (entries.isEmpty) {
    return false;
  }
  final blockStart = entries.first['index'] as int;
  final blockEnd = entries.last['index'] as int;
  final updatedEntries = <_ImportEntry>[];
  for (final entry in entries) {
    final path = entry['path'] as String;
    final newPath = _isPackageBibleFeed(path) ? _toRelative(file.path, path) : path;
    updatedEntries.add(_ImportEntry(entry['kind'] as String, entry['quote'] as String, newPath, entry['suffix'] as String));
  }
  final organised = _organise(updatedEntries);
  final originalLines = lines.sublist(blockStart, blockEnd + 1);
  final originalBlock = originalLines.join('\n');
  final newBlock = organised.join('\n');
  if (originalBlock.trim() == newBlock.trim()) {
    return false;
  }
  final newLines = <String>[];
  newLines.addAll(lines.sublist(0, blockStart));
  newLines.addAll(organised);
  newLines.addAll(lines.sublist(blockEnd + 1));
  final finalContent = newLines.join('\n') + (hadTrailingNewline ? '\n' : '');
  file.writeAsStringSync(finalContent);
  return true;
}

void main() {
  final dir = Directory(_libDir);
  if (!dir.existsSync()) {
    stderr.writeln('Directory $_libDir not found.');
    exit(1);
  }
  final files = dir.listSync(recursive: true).whereType<File>().where((file) => file.path.endsWith('.dart'));
  final changed = <String>[];
  for (final file in files) {
    if (_processFile(file)) {
      changed.add(file.path);
    }
  }
  print('Converted and organised imports in ${changed.length} files');
  for (final path in changed) {
    print(' - $path');
  }
}
