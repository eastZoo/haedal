import 'package:get/get.dart';
import 'package:haedal/service/provider/noti_provider.dart';

class NotiController extends GetxController {
  late var notis = <Noti>[].obs;
  Noti? currentNoti;
  final isLoading = false.obs;

  int pageNo = 0;
  int currentIndex = 0;

  @override
  void onInit() {
    super.onInit();
    _getNotiData();
  }

  // Set the current index
  void setCurrentIndex(int index) {
    currentIndex = index;
    update();
  }

  /// 알림 리스트 가져오기
  _getNotiData() async {
    notis.clear();
    isLoading.value = true;
    var notiData = await NotiProvider().getNotiList();

    if (notiData["data"].length != 0) {
      List<dynamic> list = notiData["data"];
      print(list);
      notis.assignAll(list.map<Noti>((item) => Noti.fromJson(item)).toList());
    }

    update();
    isLoading.value = false;
  }
}
