import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:homekey_mobile/features/auth/services/auth_storage_service.dart';
import 'package:homekey_mobile/features/property/model/property_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PropertyRepository {
  final String _baseUrl = 'http://10.119.27.17:8080/api/allProperties';
  final AuthStorageService _storage = AuthStorageService();

  Future<List<Property>> getProperties() async {
    final token = await _storage.getToken();
    final response = await http.get(
      Uri.parse('http://10.119.27.17:8080/api/propertiesFeed'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print("Response status: ${response.statusCode}");
    print("Response body34: ${response.body}");

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      // Handle both possible response structures
      final propertiesData =
          responseData['data'] is Map
              ? responseData['data']['properties'] as List<dynamic>
              : responseData['data'] as List<dynamic>;

      return propertiesData.map((json) {
        // Fix the availability typo from backend
        if (json is Map<String, dynamic>) {
          json['availability'] =
              json['avilablity'] ?? json['availability'] ?? true;
        }
        return Property.fromJson(json);
      }).toList();
    } else {
      throw Exception('Failed to load properties');
    }
  }

  // Future<Property> createProperty(
  //   String title,
  //   String description,

  Future<Property> createProperty(
    String title,
    String description,
    double price,
    String type,
    double area,
    Location location,
    int bedroom,
    String createdAt, // Optional
    List<String> amenity,
    List<String> nearbyActivities,
    File image, // Accepting a single image for now
  ) async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('Not authenticated');

    // ✅ Create images array (even for a single image)
    List<MapEntry<String, MultipartFile>> imageEntries = [];

    if (image != null) {
      final String fileName = image.path.split('/').last;
      final file = await MultipartFile.fromFile(
        image.path,
        filename: fileName,
        // It's good practice to provide contentType, though Dio often infers for files
        contentType: MediaType('image', fileName.split('.').last),
      );
      // 💡 THE FIX: Change the key from 'images[]' back to 'images' (without '[]')
      imageEntries.add(
        MapEntry('images', file),
      ); // <--- THIS IS THE REQUIRED CHANGE
    }

    // ✅ Build formData with fields
    final formData = FormData.fromMap({
      'title': title,
      'description': description,
      'price': price.toString(),
      'type': type,
      'area': area.toString(),
      'bedroom': bedroom.toString(),
      'location': jsonEncode(location.toJson()),
      'amenity': jsonEncode(amenity),
      'nearbyActivities': jsonEncode(nearbyActivities),
    });

    // ✅ Add image files as a group
    formData.files.addAll(imageEntries);

    // 🧪 Log for debugging (keep these, they are helpful)
    formData.fields.forEach((entry) {
      print('FormData field: ${entry.key} = ${entry.value}');
    });
    formData.files.forEach((entry) {
      print('FormData file: ${entry.key} = ${entry.value.filename}');
    });

    try {
      final dio = Dio();
      final response = await dio.post(
        'http://10.119.27.17:8080/api/property', // Ensure this IP is correct and accessible
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Content-Type is auto-set by Dio for FormData
          },
        ),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.data}");

      if (response.statusCode == 201) {
        return Property.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to create property: ${response.data}');
      }
    } catch (e) {
      print("Dio error: $e");
      throw Exception('Failed to create property: $e');
    }
  }

  // Add this to your PropertyRepository class
  Future<List<Property>> getUserProperties() async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.get(
      Uri.parse('http://10.119.27.17:8080/api/properties'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("User properties response status: ${response.statusCode}");
    print("User properties response body: ${response.body}");

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final propertiesData =
          responseData['data'] is Map
              ? responseData['data']['properties'] as List<dynamic>
              : responseData['data'] as List<dynamic>;

      return propertiesData.map((json) {
        if (json is Map<String, dynamic>) {
          json['availability'] =
              json['avilablity'] ?? json['availability'] ?? true;
        }
        return Property.fromJson(json);
      }).toList();
    } else {
      throw Exception('Failed to load user properties');
    }
  }

  Future<void> deleteProperty(String propertyId) async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.delete(
      Uri.parse('http://10.119.27.17:8080/api/property/$propertyId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("Delete response status: ${response.statusCode}");
    print("Delete response body: ${response.body}");

    if (response.statusCode != 204) {
      throw Exception('Failed to delete property: ${response.body}');
    }
  }
}
