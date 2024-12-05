import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart'; // For SHA-1 hashing
import 'dart:convert';
import 'dart:io';

class UserProfileStorageService {
  final String cloudName = "dzch4cn0w";
  final String apiKey = "976483172879365";
  final String apiSecret = "OZFF00hkq21qZGeBz3l_fbIOXT4";

  Future<String> uploadImage({
    required File profileImage,
    required String userEmail,
  }) async {
    final String uploadUrl =
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

    try {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      // Generate the signature
      String signature = _generateSignature({
        "timestamp": timestamp,
        "folder": "user-images/$userEmail",
      });

      // Prepare the request
      var request = http.MultipartRequest("POST", Uri.parse(uploadUrl))
        ..fields['timestamp'] = timestamp
        ..fields['signature'] = signature
        ..fields['api_key'] = apiKey
        ..fields['folder'] = "user-images/$userEmail"
        ..files
            .add(await http.MultipartFile.fromPath('file', profileImage.path));

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = json.decode(await response.stream.bytesToString());
        return responseData['secure_url']; // Return the image URL
      } else {
        // Log error details
        print("Failed to upload image: ${response.statusCode}");
        print("Response body: ${await response.stream.bytesToString()}");
        return "";
      }
    } catch (e) {
      print("Error uploading image: $e");
      return "";
    }
  }

  String _generateSignature(Map<String, String> parameters) {
    final sortedParams = parameters.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final paramString =
        sortedParams.map((e) => "${e.key}=${e.value}").join('&');
    final signature = sha1.convert(utf8.encode('$paramString$apiSecret'));
    return signature.toString();
  }
}
