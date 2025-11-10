import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ImageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();
  final Uuid _uuid = const Uuid();

  Future<File?> pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  Future<String?> uploadImage(File imageFile, String chatId) async {
    try {
      final String fileName = '${_uuid.v4()}.jpg';
      final Reference storageRef = _storage
          .ref()
          .child('chat_images')
          .child(chatId)
          .child(fileName);

      final UploadTask uploadTask = storageRef.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        print('Progreso de carga: ${(progress * 100).toStringAsFixed(2)}%');
      });

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      if (imageUrl.isNotEmpty) {
        final Reference storageRef = _storage.refFromURL(imageUrl);
        await storageRef.delete();
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  Future<File?> compressImage(File imageFile) async {
    try {
      // paquete flutter_image_compress
      return imageFile;
    } catch (e) {
      print('Error compressing image: $e');
      return imageFile;
    }
  }
}
