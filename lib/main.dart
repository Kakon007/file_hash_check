import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: library_prefixes
import 'package:crypto/crypto.dart' as hashChecker;

String? filePath;
var fileHash;
var filePickerProvider = StateProvider((ref) {
  return filePath;
});

var hashProvider = StateProvider((ref) {
  return fileHash;
});

void main() {
  runApp(const ProviderScope(child: MaterialApp(home: FileHashChkScreen())));
}

class FileHashChkScreen extends ConsumerWidget {
  const FileHashChkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchFilePat = ref.watch(filePickerProvider);
    final watchHash = ref.watch(hashProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Hash Chk'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'FilePath : $watchFilePat',
            ),
            Text(
              'FileHash : $watchHash',
            ),
            ElevatedButton(
                onPressed: () async {
                  var pickFilePath = FilePicker.platform.pickFiles();
                  await pickFilePath.then((value) {
                    filePath = value?.files.single.path;
                  });

                  var converStringToFile = File(filePath!);
                  if (converStringToFile.toString().isEmpty) return;

                  fileHash = await hashChecker.md5
                      .bind(converStringToFile.openRead())
                      .first;
                  ref.read(hashProvider.notifier).state = fileHash;
                  ref
                      .read(filePickerProvider.notifier)
                      .update((state) => filePath);
                },
                child: const Text('Pick File'))
          ],
        ),
      ),
    );
  }
}
