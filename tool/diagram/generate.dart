// ignore_for_file: avoid_print

import 'dart:io';

const _lakosFlags = '-m --node-metrics --no-tree';
const _diagramDir = '_diagram';
const _gvprScript = 'tool/diagram/f_color-nodes.gvpr';

const _diagrams = <String, String>{
  'manager': '{injectable*,main.dart,model/**,view/**}',
  'view': '{injectable*,model/**,manager/**,view/_*,view/**/_*}',
  'all': '{injectable*,model/**,view/_*,view/**/_*}',
  'model': '{injectable*,main.dart,manager/**,service/**,view/**}',
};

Future<void> _generateDiagram(String name, String excludePattern) async {
  final outputPath = '$_diagramDir/$name.svg';
  final command =
      'dart run lakos $_lakosFlags -i \'$excludePattern\' lib '
      '| gvpr -cf $_gvprScript '
      '| sfdp -Goverlap=false -Gsep=+10 -Gsplines=true -Tsvg '
      '-o $outputPath';

  print('Generating $name.svg...');
  final process = await Process.start('sh', ['-c', command]);
  final exitCode = await process.exitCode;

  if (exitCode != 0) {
    stderr.writeln('Failed to generate $name.svg (exit code: $exitCode)');
    exit(1);
  }
  print('Generated $outputPath');
}

Future<void> main() async {
  final diagramDirectory = Directory(_diagramDir);
  if (!diagramDirectory.existsSync()) {
    diagramDirectory.createSync();
  }

  for (final entry in _diagrams.entries) {
    await _generateDiagram(entry.key, entry.value);
  }

  print('All diagrams generated successfully.');
}
