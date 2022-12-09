import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:lovelace/models/storage_item.dart';

// contains the methods used for CRUD functions from secured storage
class StorageService {
  final _secureStorage = const FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true
  );

  Future<void>writeSecureData(StorageItem newItem) async {
    debugPrint("Writing new data having key ${newItem.key}");
    await _secureStorage.write(
      key: newItem.key, value: newItem.value, aOptions: _getAndroidOptions()
    );
  }

  Future<String?> readSecureData(String key) async {
    debugPrint("Reading data with key $key");
    var readData = await _secureStorage.read(key: key, aOptions: _getAndroidOptions());
    return jsonEncode(readData);
  }

  Future<void> deleteSecureData(StorageItem item) async {
    debugPrint("Deleting data having key ${item.key}");
    await _secureStorage.delete(key: item.key, aOptions: _getAndroidOptions());
  }

  Future<List<StorageItem>> readAllSecureData() async {
    debugPrint("Reading all secured data");
    var allData = await _secureStorage.readAll(aOptions: _getAndroidOptions());
    List<StorageItem> list = allData.entries.map((e) => StorageItem(e.key, e.value)).toList();
    return list; // return all secureData in a list
  }

  Future<void> deleteAllSecureData() async {
    debugPrint("Deleting all secured data");
    await _secureStorage.deleteAll(aOptions: _getAndroidOptions());
  }

  Future<bool> containsKeyInSecureData(String key) async {
    debugPrint("Checking for the key $key");
    var containsKey = await _secureStorage.containsKey(
      key: key, aOptions: _getAndroidOptions()
    );
    return containsKey;
  }
}
