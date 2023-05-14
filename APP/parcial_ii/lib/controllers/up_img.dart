import 'package:parcial_ii/exports.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'dart:io';

class UpImage {
  static Future<String?> uploadImageToCloudinary(File imageFile) async {
    final cloudinary = CloudinaryPublic('dwfh4s7tu', 'parcial_II');
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageFile.path),
      );

      return response.secureUrl;
    } catch (e) {
      return null;
    }
  }
}
