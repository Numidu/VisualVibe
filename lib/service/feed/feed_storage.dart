import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart'; // Add this dependency in pubspec.yaml
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore package

class FeedStorage {
  final String cloudName =
      "dzch4cn0w"; // Replace with your Cloudinary cloud name
  final String apiKey =
      "976483172879365"; // Replace with your Cloudinary API key
  final String apiSecret =
      "OZFF00hkq21qZGeBz3l_fbIOXT4"; // Replace with your Cloudinary API secret

  // Upload image to Cloudinary
  Future<String> uploadImage({required File postImage}) async {
    final url = "https://api.cloudinary.com/v1_1/$cloudName/image/upload";
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000; // Seconds

    // Generate HMAC-SHA1 signature
    final String data = "timestamp=$timestamp$apiSecret";
    final String signature = sha1.convert(utf8.encode(data)).toString();

    final request = http.MultipartRequest("POST", Uri.parse(url));
    request.fields['api_key'] = apiKey;
    request.fields['timestamp'] = timestamp.toString();
    request.fields['signature'] = signature;
    request.files
        .add(await http.MultipartFile.fromPath('file', postImage.path));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        return data['secure_url']; // Return the Cloudinary image URL
      } else {
        print("Upload failed: ${response.statusCode}");
        return "";
      }
    } catch (error) {
      print("Error uploading image: $error");
      return "";
    }
  }

  Future<void> deleteImage({required String imageUrl}) async {
    // Extract public_id from the imageUrl (if needed for deletion)
    print("Cloudinary deletion requires public_id, handle accordingly.");
  }
}
