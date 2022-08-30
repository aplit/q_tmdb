import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<Directory> getTemporaryDir() async {
  return getTemporaryDirectory();
}

Future<Directory> getCacheDir() async {
  return getApplicationDocumentsDirectory();
}

Future<Directory?> getExternalStorageDir() async {
  return getExternalStorageDirectory();
}

Future<File?> getTemporaryFile(String filename) async {
  if (filename == null || filename.isEmpty) {
    return null;
  }
  Directory directory = await getTemporaryDir();
  File file = File('${directory.path}/$filename');
  print('FileUtilities >> getTemporaryFile directory:$directory' +
      '|file:$file***');
  return file;
}

Future<File?> getExternalFile(String filename) async {
  if (filename == null || filename.isEmpty) {
    return null;
  }
  Directory? directory = await getExternalStorageDir();
  File file = File('${directory?.path}/$filename');
  print('FileUtilities >> getExternalFile directory:$directory' +
      '|file:$file***');
  return file;
}
