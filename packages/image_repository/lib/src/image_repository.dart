import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class ImageRepository {
  const ImageRepository();

  static final ImagePicker _picker = ImagePicker();

  Future<String> pickImage() async {
    XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      return file.path;
    }
    return '';
  }

  Future<Uint8List> loadImage(String path) async {
    if (path.isNotEmpty) {
      var hasLocalImage = File(path).existsSync();
      if (hasLocalImage) {
        return await File(path).readAsBytes();
      }
    }
    return Uint8List.fromList([]);
  }
}
