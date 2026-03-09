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
  static const String compIpAdress = "192.168.1.95";

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
  static String StudentUpdateProfile = '/auth/update-profile';

  // ============ bike Endpoints ============
  static const String bike = '/bike';
  static String itemById(String id) => '/items/$id';
  static String itemClaim(String id) => '/items/$id/claim';
  static String bikeById(String id) => '/bike/$id';
  static String bikeByName(String name) => '/bike/name/$name';

  // ============ Admin User Endpoints ============
  // Express: app.use('/api/admin/users', adminUserRoutes)
  static const String adminUsers = '/admin/users'; // GET all, POST create
  static String adminUserById(String id) =>
      '/admin/users/$id'; // GET one, PUT update, DELETE
  static const String adminUploadImage = '/admin/users/upload-image';

  static String itemUplodeVideo = '/auth/uplode-video';
  // ============ Notification Endpoints ============
  static const String notification = '/notification';
  static String notificationMarkRead(String id) => '/notification/$id/read';
  static const String notificationReadAll = '/notification/read-all';
  static const String notificationUnreadCount = '/notification/unread-count';

  // ============ booking Endpoints ============
  static const String booking = '/booking';

  static const String uplodedocument = '/dl';
  static String commentById(String id) => '/comments/$id';
  static String commentsByItem(String itemId) => '/comments/item/$itemId';
  static String commentLike(String id) => '/comments/$id/like';
}
