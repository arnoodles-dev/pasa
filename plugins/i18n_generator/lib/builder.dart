import 'dart:async';
import 'dart:convert' show jsonDecode;
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

import './i18n_config.dart';
import './i18n_template.dart';
import './logger.dart';

// ignore_for_file: depend_on_referenced_packages
Logger logger = Logger();

void resourceDartBuilder(
  File workPath,
  String outputPath, {
  required bool isWatch,
}) {
  ResourceDartBuilder(workPath.absolute.path, outputPath)
    ..generateResourceDartFile()
    ..setIsWatch(isWatch: isWatch)
    ..watchFileChange();
}

class ResourceDartBuilder {
  ResourceDartBuilder(this.projectRootPath, this.outputPath);

  bool _isWatch = false;

  /// convert the set to the list
  I18nConfig? i18nConfig;

  /// all of the directory with yaml.
  List<FileSystemEntity> dirList = <FileSystemEntity>[];

  final bool isWriting = false;
  File? _resourceFile;

  // ignore: use_setters_to_change_properties
  void setIsWatch({required bool isWatch}) {
    _isWatch = isWatch;
  }

  bool get isWatch => _isWatch;

  void generateResourceDartFile() {
    log('Prepare generate resource dart file.');
    final String pubYamlPath = Platform.isMacOS
        ? '${projectRootPath}pubspec.yaml'
        : '$projectRootPath${separator}pubspec.yaml';
    try {
      final I18nConfig i18nconfig = I18nConfig.fromYaml(
        _getI18nConfig(pubYamlPath),
      );

      final String path = _getAbsolutePath(
        '${i18nconfig.localePath}${i18nconfig.defaultLocale}.json',
      );
      final Map<String, dynamic> i18nItems = getLocalizedString(
        Platform.isMacOS ? '$projectRootPath$path' : path,
      );

      generateI18n(i18nItems);
    } catch (e) {
      if (e is StackOverflowError) {
        writeText(e.stackTrace);
      } else {
        writeText(e);
      }
      log('error $e');
    }
    log('Generate dart resource file finish.');

    watchFileChange();
  }

  File get logFile => File('.dart_tool${separator}log.txt');

  final String projectRootPath;
  final String outputPath;

  /// write the
  /// default file is a log file in the .dart_tools/log.txt
  void writeText(Object? text, {File? file}) {
    file ??= logFile;
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    file
      ..writeAsStringSync(DateTime.now().toString(), mode: FileMode.append)
      ..writeAsStringSync('  : $text', mode: FileMode.append)
      ..writeAsStringSync('\n', mode: FileMode.append);
  }

  /// get the flutter asset path from yaml
  YamlMap _getI18nConfig(String yamlPath) {
    final File file = File(yamlPath);
    dirList.add(file);
    log('yaml path: $yamlPath');
    final YamlMap map = loadYaml(file.readAsStringSync()) as YamlMap;
    // writeText(map.toString());
    final dynamic i18nConfigMap = map['i18nconfig'];
    if (i18nConfigMap is YamlMap) {
      // writeText("i18nConfigMap is yamlMap");
      return i18nConfigMap;
    }
    throw Error();
  }

  Map<String, dynamic> getLocalizedString(String path) {
    final File file = File(path);
    dirList.add(file);
    log('json path: $path');

    return jsonDecode(
      file.readAsStringSync(),
    ) as Map<String, dynamic>;
  }

  /// get the asset from yaml list
  List<String> getListFromYamlList(YamlList yamlList) {
    final List<String> list = <String>[];
    final List<String> r =
        yamlList.map((dynamic value) => value.toString()).toList();
    list.addAll(r);
    return list;
  }

  String _getAbsolutePath(String path) {
    final File f = File(path);
    if (f.isAbsolute) {
      return path;
    }
    return '$projectRootPath/$path';
  }

  File get resourceFile {
    if (File(outputPath).isAbsolute) {
      _resourceFile ??= File(outputPath);
    } else {
      _resourceFile ??= File('$projectRootPath/$outputPath');
    }

    _resourceFile?.createSync(recursive: true);

    return _resourceFile!;
  }

  void generateI18n(Map<String, dynamic> i18nItems) {
    writeText('start write code');
    resourceFile
      ..deleteSync(recursive: true)
      ..createSync(recursive: true);
    final IOSink lock = resourceFile.openWrite(mode: FileMode.append);
    void generate(String text) {
      lock.write(text);
    }

    final I18nTemplate template = I18nTemplate();
    generate(template.license);
    generate(template.classDeclare);
    generate(template.classDeclareFunctions);
    i18nItems.forEach((String key, dynamic value) {
      log('$key $value');
      generate(template.formatFiled(key, value.toString()));
    });
    generate(template.classDeclareFooter);
    lock.close();
    writeText('end write code');
  }

  /// watch all of path
  void watchFileChange() {
    if (!isWatch) return;

    setIsWatch(isWatch: true);
    for (final FileSystemEntity dir in dirList) {
      // ignore: cancel_subscriptions
      final StreamSubscription<FileSystemEvent>? sub = _watch(dir);
      if (sub != null) {
        watchMap[dir] = sub;
      }
    }

    log('watching files watch');
  }

  /// when the directory is change
  /// refresh the code
  StreamSubscription<FileSystemEvent>? _watch(FileSystemEntity file) {
    log('[_watch] ${file.existsSync() ? '    is exists' : 'is not exists'} ${file.uri}');
    if (FileSystemEntity.isWatchSupported) {
      return file.watch().listen((FileSystemEvent data) {
        log('${data.path} is changed.');
        generateResourceDartFile();
      });
    }
    return null;
  }

  Map<FileSystemEntity, StreamSubscription<FileSystemEvent>> watchMap =
      <FileSystemEntity, StreamSubscription<FileSystemEvent>>{};

  void removeAllWatches() {
    for (final StreamSubscription<FileSystemEvent> v in watchMap.values) {
      v.cancel();
    }
  }
}
