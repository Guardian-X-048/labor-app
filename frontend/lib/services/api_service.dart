import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String _baseUrl() {
    if (kIsWeb) {
      final host = Uri.base.host;
      if (host == 'localhost' || host == '127.0.0.1') {
        return 'http://localhost:5000';
      }
      return 'https://api.laborlinks.in';
    }

    return 'http://10.0.2.2:5000';
  }

  static Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${_baseUrl()}/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'password': password}),
    );

    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> signup({
    required String name,
    required String phone,
    required String password,
    required String role,
  }) async {
    final response = await http.post(
      Uri.parse('${_baseUrl()}/api/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'password': password,
        'role': role,
      }),
    );

    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> verifyAadhaar({
    required String token,
    required String aadhaarNumber,
  }) async {
    final response = await http.post(
      Uri.parse('${_baseUrl()}/api/aadhaar/verify'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'aadhaarNumber': aadhaarNumber}),
    );

    return _decodeResponse(response);
  }

  static Future<List<Map<String, dynamic>>> fetchJobs() async {
    final response = await http.get(Uri.parse('${_baseUrl()}/api/jobs'));
    final decoded = _decodeResponse(response);
    final list = decoded['data'] as List<dynamic>;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static Future<Map<String, dynamic>> postJob({
    required String token,
    required String title,
    required String description,
    required String location,
    required String wage,
  }) async {
    final response = await http.post(
      Uri.parse('${_baseUrl()}/api/jobs'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'description': description,
        'location': location,
        'wage': wage,
      }),
    );

    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> applyToJob({
    required String token,
    required String jobId,
  }) async {
    final response = await http.post(
      Uri.parse('${_baseUrl()}/api/applications'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'jobId': jobId}),
    );

    return _decodeResponse(response);
  }

  static Future<List<Map<String, dynamic>>> fetchMyApplications({
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('${_baseUrl()}/api/applications/my'),
      headers: {'Authorization': 'Bearer $token'},
    );
    final decoded = _decodeResponse(response);
    final list = decoded['data'] as List<dynamic>;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static Future<List<Map<String, dynamic>>> fetchEmployerJobs({
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('${_baseUrl()}/api/jobs/my'),
      headers: {'Authorization': 'Bearer $token'},
    );
    final decoded = _decodeResponse(response);
    final list = decoded['data'] as List<dynamic>;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static Future<List<Map<String, dynamic>>> fetchApplicantsForJob({
    required String token,
    required String jobId,
  }) async {
    final response = await http.get(
      Uri.parse('${_baseUrl()}/api/applications/job/$jobId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    final decoded = _decodeResponse(response);
    final list = decoded['data'] as List<dynamic>;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static Future<Map<String, dynamic>> updateApplicationStatus({
    required String token,
    required String applicationId,
    required String status,
  }) async {
    final response = await http.patch(
      Uri.parse('${_baseUrl()}/api/applications/$applicationId/status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': status}),
    );

    return _decodeResponse(response);
  }

  static Map<String, dynamic> _decodeResponse(http.Response response) {
    final decoded = response.body.isEmpty ? null : jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded is List) {
        return {'data': decoded};
      }

      final body = decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
      if (body.containsKey('message') || body.containsKey('token') || body.containsKey('user')) {
        return body;
      }
      return {'data': body};
    }

    final body = decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
    throw Exception(body['message'] ?? 'Request failed with status ${response.statusCode}');
  }
}
