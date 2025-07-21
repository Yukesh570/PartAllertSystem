import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';

AudioPlayer player = AudioPlayer();

Future<void> pickAndPlaySound() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.audio,
  );

  if (result != null && result.files.single.path != null) {
    String? path = result.files.single.path;
    await player.play(DeviceFileSource(path!));
  }
}
