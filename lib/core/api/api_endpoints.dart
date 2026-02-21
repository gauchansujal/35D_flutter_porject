import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - change this for production
  // static const String baseUrl = 'http://10.0.2.2:5000/api/';
  //static const String baseUrl = 'http://localhost:5000/api/';
  // For Android Emulator use: 'http://10.0.2.2:5000/api/'
  // For iOS Simulator use: 'http://localhost:5000/api/'
  // For Physical Device use your computer's IP: 'http://192.168.x.x:5000/api/'
  static const bool isPhysicalDevice = false;
  static const String compIpAdress = "";

  static String get baseUrl {
    if (isPhysicalDevice) {
      return 'http://$compIpAdress:5000/api/';
    }

    if (kIsWeb) {
      return 'http://localhost:5000/api/';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000/api/';
    } else if (Platform.isIOS) {
      return 'http://localhost:5000/api/';
    } else {
      return 'http://localhost:5000/api/';
    }
  }

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============ Batch Endpoints ============
  // static const String batches = '/batches';
  // static String batchById(String id) => '/batches/$id';

  // ============ Category Endpoints ============
  static const String categories = '/categories';
  static String categoryById(String id) => '/categories/$id';

  // ============ Student Endpoints ============
  static const String students = '/auth';
  static const String studentLogin = '/auth/login';
  static const String studentRegister = '/auth/register';
  static String studentById(String id) => '/auth/$id';
  static String studentPhoto(String id) => '/auth/$id/photo';
  static String uploadProfileImage = '/auth/update-profile';

  // ============ Item Endpoints ============
  static const String items = '/items';
  static String itemById(String id) => '/items/$id';
  static String itemClaim(String id) => '/items/$id/claim';

  static String itemUplodeVideo = '/auth/uplode-video';

  // ============ Comment Endpoints ============
  static const String comments = '/comments';

  static const String login = '/login';
  static String commentById(String id) => '/comments/$id';
  static String commentsByItem(String itemId) => '/comments/item/$itemId';
  static String commentLike(String id) => '/comments/$id/like';
}
