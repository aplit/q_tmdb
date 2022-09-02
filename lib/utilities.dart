import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<bool> checkFileExists(File file) async {
  bool existing = await file.exists();
  return existing;
}

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
  if (filename.isEmpty) {
    return null;
  }
  Directory directory = await getTemporaryDir();
  File file = File('${directory.path}/$filename');
  print('FileUtilities >> getTemporaryFile filePath:${file.path}***');
  return file;
}

Future<File?> getExternalFile(String filename) async {
  if (filename.isEmpty) {
    return null;
  }
  Directory? directory = await getExternalStorageDir();
  File file = File('${directory?.path}/$filename');
  print('FileUtilities >> getExternalFile filePath:${file.path}***');
  return file;
}

Future<File?> downloadFile(String url, File destFile) async {
  print('FileUtilities >> downloadFile url:${url != null ? url : 'NULL'}' +
      '|destFile:${destFile != null ? destFile : 'NULL'}***');
  if (url == null || url.isEmpty) {
    return null;
  }
  if (destFile == null) {
    return null;
  }
  ByteData? byteData = await downloadData(url);
  if (byteData == null) {
    return null;
  }
  return writeToFile(byteData, destFile);
}

Future<ByteData?> downloadData(String url) async {
  print('FileUtilities >> downloadData url:${url != null ? url : 'NULL'}' +
      '***');
  if (url == null || url.isEmpty) {
    return null;
  }
  final ByteData byteData = await NetworkAssetBundle(Uri.parse(url)).load("");
  return byteData;
}

Future<File>? writeToFile(ByteData data, File destFile) {
  print('FileUtilities >> writeToFile dataNotNull:${data != null}' +
      '|destFile:${destFile != null ? destFile : 'NULL'}***');
  if (data == null) {
    return null;
  }
  if (destFile == null) {
    return null;
  }
  return destFile.writeAsBytes(data.buffer.asUint8List());
}

Future<Image?> downloadPhoto(String photoUrl) async {
  print('ImageUtilities >> downloadPhoto photoUrl:$photoUrl***');
  ByteData? byteData = await downloadData(photoUrl);
  if (byteData == null) {
    return null;
  }
  return Image.memory(byteData.buffer.asUint8List());
}

Image? getImageWithDimension(
    File file, double width, double height, BoxFit fit) {
  print('ImageUtilities >> getImageWithDimension fileNotNull:${file != null}' +
      '|width:$width|height:$height' +
      '***');
  if (file == null) {
    return null;
  }
  print('ImageUtilities >> getImageWithDimension file:${file.path}***');
  return Image.file(
    file,
    width: width,
    height: height,
    fit: fit,
  );
}

Widget getNavigationBar(int selectedIndex, dynamic onItemTapped) {
  print('ViewUtilities >> getNavigationBar selectedIndex:$selectedIndex***');
  return BottomNavigationBar(
    currentIndex: selectedIndex,
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.black54,
    showUnselectedLabels: true,
    showSelectedLabels: true,
    onTap: onItemTapped,
    selectedFontSize: 11,
    unselectedFontSize: 11,
    type: BottomNavigationBarType.fixed,
    items: const [
      BottomNavigationBarItem(
        icon: Image(
          image: AssetImage('assets/icon_nav_popular_movies.png'),
          fit: BoxFit.contain,
          width: 24,
        ),
        activeIcon: Image(
          image: AssetImage('assets/icon_nav_popular_movies_selected.png'),
          fit: BoxFit.contain,
          width: 24,
        ),
        label: 'Popular Movies',
      ),
      BottomNavigationBarItem(
        icon: Image(
          image: AssetImage('assets/icon_nav_genres.png'),
          fit: BoxFit.contain,
          width: 24,
        ),
        activeIcon: Image(
          image: AssetImage('assets/icon_nav_genres_selected.png'),
          fit: BoxFit.contain,
          width: 24,
        ),
        label: 'Genres',
      ),
    ],
  );
}
