part of "../../recollect_utils.dart";

class XTX {
  static Future<Result<void>> delete(String fullPath) async {
    if (await File(fullPath).exists()) {
      try {
        final file = File(fullPath);
        if (!await file.exists()) {
          return Result.failure('File not found');
        }

        await file.delete();
        return Result.success(null);
      } catch (e) {
        return Result.failure('Failed to delete file: $e');
      }
    } else {
      try {
        if (kDebugMode) {
          print('Deleting folder: $fullPath');
        }

        final folder = Directory(fullPath);
        if (!await folder.exists()) {
          return Result.failure('Folder not found');
        }

        await folder.delete(recursive: true);

        return Result.success(null);
      } catch (e) {
        if (kDebugMode) {
          print('Error deleting folder: $e');
        }
        return Result.failure('Failed to delete folder: $e');
      }
    }
  }

  static String name(String string) => path.basenameWithoutExtension(string);

  static String extension(String string) => "xtx";

  static List<FileSystemEntity> listDirectory(String dirPath) {
    return Directory(dirPath)
        .listSync(followLinks: false)
        .where((entity) => !path.basename(entity.path).startsWith('.app'))
        .toList();
  }

  static Future<Result<String>> renameFile(
    String filePath,
    String newName,
  ) async {
    try {
      final file = File(filePath);
      final folder = Directory(filePath);
      final isFile = await file.exists();
      final isFolder = await folder.exists();

      if (!isFile && !isFolder) {
        return Result.failure('File or folder not found');
      }

      if (isValidFileName(newName)) {
        return Result.failure('Invalid file name');
      }

      final directory = path.dirname(filePath);
      final newFilePath = path.join(directory, newName);

      if (await File(newFilePath).exists() ||
          await Directory(newFilePath).exists()) {
        return Result.failure('A file or folder with that name already exists');
      }

      if (isFile) {
        await file.rename(newFilePath);
      } else {
        await folder.rename(newFilePath);
      }

      return Result.success(newFilePath);
    } catch (e) {
      return Result.failure('Failed to rename file: $e');
    }
  }

  static Future<Result<String>> duplicateFile(String filePath) async {
    try {
      final originalFile = File(filePath);
      if (!await originalFile.exists()) {
        return Result.failure('Original file not found');
      }

      final directory = path.dirname(filePath);
      final baseName = path.basenameWithoutExtension(filePath);
      final extension = path.extension(filePath);

      final newName = await _findUniqueFileName(
        directory,
        '${baseName}_copy',
        extension,
      );
      final newPath = path.join(directory, '$newName$extension');

      await File(filePath).copy(newPath);
      return Result.success(newPath);
    } catch (e) {
      return Result.failure('Failed to duplicate file: $e');
    }
  }

  static Future<Result<String>> moveFile(
    String sourcePath,
    String targetFolderPath, {
    bool autoRename = false,
  }) async {
    try {
      final sourceFile = File(sourcePath);
      final sourceFolder = Directory(sourcePath);
      final isSourceFile = await sourceFile.exists();
      final isSourceFolder = await sourceFolder.exists();

      if (!isSourceFile && !isSourceFolder) {
        return Result.failure('Source file or folder not found');
      }

      final targetFolder = Directory(targetFolderPath);
      if (!await targetFolder.exists()) {
        return Result.failure('Target folder does not exist');
      }

      if (isSourceFolder && _isPathDescendant(targetFolderPath, sourcePath)) {
        return Result.failure('Cannot move folder into itself or its children');
      }

      final sourceName = path.basename(sourcePath);
      String targetPath = path.join(targetFolderPath, sourceName);

      if (await File(targetPath).exists() ||
          await Directory(targetPath).exists()) {
        if (autoRename) {
          targetPath = await _findUniqueTargetPath(
            targetFolderPath,
            sourceName,
          );
        } else {
          return Result.failure(
            'A file or folder with that name already exists in the target location',
          );
        }
      }

      if (isSourceFile) {
        await File(sourcePath).rename(targetPath);
      } else {
        await Directory(sourcePath).rename(targetPath);
      }

      return Result.success(targetPath);
    } catch (e) {
      return Result.failure('Failed to move file: $e');
    }
  }

  static bool _isPathDescendant(String childPath, String parentPath) {
    final normalizedChild = path.normalize(childPath);
    final normalizedParent = path.normalize(parentPath);

    return normalizedChild.startsWith(
          '$normalizedParent${Platform.pathSeparator}',
        ) ||
        normalizedChild == normalizedParent;
  }

  static Future<String> _findUniqueTargetPath(
    String targetDirectory,
    String itemName,
  ) async {
    final extension = path.extension(itemName);
    final baseName = path.basenameWithoutExtension(itemName);

    String candidate = itemName;
    int counter = 1;

    while (await File(path.join(targetDirectory, candidate)).exists() ||
        await Directory(path.join(targetDirectory, candidate)).exists()) {
      candidate = extension.isNotEmpty
          ? '$baseName$counter$extension'
          : '${baseName}_$counter';
      counter++;
    }

    return path.join(targetDirectory, candidate);
  }

  static Future<String> _findUniqueFileName(
    String directory,
    String baseName,
    String extension,
  ) async {
    String candidate = '$baseName$extension';
    if (!await File(path.join(directory, candidate)).exists()) {
      return candidate;
    }

    int counter = 1;
    while (true) {
      candidate = '$baseName - ($counter)$extension';
      if (!await File(path.join(directory, candidate)).exists()) {
        return candidate;
      }
      counter++;
    }
  }

  static Future<Result<String>> renameFolder(
    String folderPath,
    String newName,
  ) async {
    try {
      if (kDebugMode) {
        print('Renaming folder: $folderPath to $newName');
      }

      final folder = Directory(folderPath);
      if (!await folder.exists()) {
        return Result.failure('Folder not found');
      }

      if (!isValidFileName(newName)) {
        return Result.failure('Invalid folder name');
      }

      final parentDir = path.dirname(folderPath);
      final newFolderPath = path.join(parentDir, newName);

      if (await Directory(newFolderPath).exists() ||
          await File(newFolderPath).exists()) {
        return Result.failure('A file or folder with that name already exists');
      }

      await folder.rename(newFolderPath);
      return Result.success(newFolderPath);
    } catch (e) {
      if (kDebugMode) {
        print('Error renaming folder: $e');
      }
      return Result.failure('Failed to rename folder: $e');
    }
  }

  static Future<Result<String>> createFolder(
    String parentPath,
    String name,
  ) async {
    try {
      if (kDebugMode) {
        print('Creating folder: $name in $parentPath');
      }

      if (!await Directory(parentPath).exists()) {
        return Result.failure('Parent directory does not exist');
      }

      if (!isValidFileName(name)) {
        return Result.failure('Invalid folder name');
      }

      final folderPath = path.join(parentPath, name);
      final folder = Directory(folderPath);

      if (await folder.exists()) {
        return Result.failure('A folder with that name already exists');
      }

      await folder.create(recursive: true);

      return Result.success(folderPath);
    } catch (e) {
      if (kDebugMode) {
        print('Error creating folder: $e');
      }
      return Result.failure('Failed to create folder: $e');
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
        } catch (e) {
          if (kDebugMode) {
            print('⚠️ Could not unhide .meta file: $e');
          }
        }
      }

      await metaFile.writeAsString(meta.toJsonString());

      if (Platform.isWindows) {
        try {
          await Process.run('attrib', ['+H', metaFilePath]);
        } catch (e) {
          if (kDebugMode) {
            print('⚠️ Could not hide .meta file: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error saving folder meta for $folderPath: $e');
      }
    }
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
