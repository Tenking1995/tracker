import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tracker/common/general_controller.dart';

import 'chart_index.dart';

class ChartBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChartController>(() => ChartController());
  }
}

class ChartController extends GetxController {
  final state = ChartState();
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  bool isNeedRefresh = false;

  onRefresh() {
    getCategories();
  }

  void getCategories() {
    GeneralController.to.refreshExpensesList();
    refreshController.refreshCompleted(resetFooterState: true);
    update();
  }
}
