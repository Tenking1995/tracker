import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageHelper extends GetxService {
  StorageHelper._();

  static StorageHelper get to {
    if (!Get.isRegistered<StorageHelper>()) {
      Get.put(StorageHelper._(), permanent: true);
    }
    return Get.find<StorageHelper>();
  }

  final box = GetStorage();

  Future store(String key, dynamic value) async {
    return await box.write(key, value);
  }

  //get<String>('username')
  Future get(String key) async {
    return await box.read(key);
  }

  bool isExist(String key) {
    return box.hasData(key);
  }
}
