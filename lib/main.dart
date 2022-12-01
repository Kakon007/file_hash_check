import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String? file;
var filePickerProvider = StateProvider((ref) {
  return file;
});

void main() {
  runApp(const ProviderScope(child: MaterialApp(home: FileHashChkScreen())));
}

class FileHashChkScreen extends ConsumerWidget {
  const FileHashChkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchFilePat = ref.watch(filePickerProvider);
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
            ElevatedButton(
                onPressed: () async {
                  var pickFilePath = FilePicker.platform.pickFiles();
                  await pickFilePath.then((value) {
                    file = value?.files.single.path;
                  });
                  ref.read(filePickerProvider.notifier).update((state) => file);
                },
                child: const Text('Pick File'))
          ],
        ),
      ),
    );
  }
}
