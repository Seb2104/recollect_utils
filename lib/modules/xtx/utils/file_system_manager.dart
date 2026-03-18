part of '../../../recollect_utils.dart';

class FileSystemManager {
  Future<Result> renameFolder(String folderPath, String newName) async {
    try {
      final folder = Directory(folderPath);
      if (!await folder.exists()) {
        return Result.failure(null);
      }

      if (!isValidFileName(newName)) {
        return Result.failure(null);
      }

      final parentDir = path.dirname(folderPath);
      final newFolderPath = path.join(parentDir, newName);

      if (await Directory(newFolderPath).exists() ||
          await File(newFolderPath).exists()) {
        return Result.failure(null);
      }

      await folder.rename(newFolderPath);
      return Result.success(null);
    } catch (e) {
      return Result.failure(null);
    }
  }

  Future<Result> deleteFolder(String folderPath) async {
    try {
      final folder = Directory(folderPath);
      if (!await folder.exists()) {
        return Result.failure(null);
      }

      await folder.delete(recursive: true);

      return Result.success(null);
    } catch (e) {
      return Result.failure(null);
    }
  }

  Future<Result> createFolder(String parentPath, String name) async {
    try {
      if (!await Directory(parentPath).exists()) {
        return Failure(null);
      }

      if (!isValidFileName(name)) {
        return Failure(null);
      }

      final folderPath = path.join(parentPath, name);
      final folder = Directory(folderPath);

      if (await folder.exists()) {
        return Result.failure(null);
      }

      await folder.create(recursive: true);

      return Result.success(null);
    } catch (e) {
      return Result.failure(null);
    }
  }

  static bool isValidFileName(String name) {
    if (name.trim().isEmpty) return false;

    const invalidChars = ['/', '\\', ':', '*', '?', '"', '<', '>', '|'];
    for (final char in invalidChars) {
      if (name.contains(char)) return false;
    }

    const reservedNames = [
      'CON',
      'PRN',
      'AUX',
      'NUL',
      'COM1',
      'COM2',
      'COM3',
      'COM4',
      'COM5',
      'COM6',
      'COM7',
      'COM8',
      'COM9',
      'LPT1',
      'LPT2',
      'LPT3',
      'LPT4',
      'LPT5',
      'LPT6',
      'LPT7',
      'LPT8',
      'LPT9',
    ];

    return !reservedNames.contains(name.toUpperCase());
  }

  static Future<FolderMeta> loadFolderMeta(String folderPath) async {
    final metaFile = File('$folderPath/.meta');

    final content = await metaFile.readAsString();
    return FolderMeta.fromJsonString(content);
  }

  static Future<void> saveFolderMeta(String folderPath, FolderMeta meta) async {
    try {
      final metaFilePath = path.join(folderPath, '.meta');
      final metaFile = File(metaFilePath);

      if (meta.isEmpty) {
        if (await metaFile.exists()) {
          await metaFile.delete();
        }
        return;
      }

      final folder = Directory(folderPath);
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }

      if (Platform.isWindows && await metaFile.exists()) {
        try {
          await Process.run('attrib', ['-H', metaFilePath]);
        } catch (e) {}
      }

      await metaFile.writeAsString(meta.toJsonString());

      if (Platform.isWindows) {
        try {
          await Process.run('attrib', ['+H', metaFilePath]);
        } catch (e) {}
      }
    } catch (e) {}
  }

  static Future<String?> getFolderIcon(String folderPath) async {
    final meta = await loadFolderMeta(folderPath);
    return meta.customIcon;
  }

  static Future<void> setFolderIcon(String folderPath, String? icon) async {
    final currentMeta = await loadFolderMeta(folderPath);
    final updatedMeta = currentMeta.copyWith(customIcon: icon);
    await saveFolderMeta(folderPath, updatedMeta);
  }
}
