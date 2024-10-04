

import 'package:get/get.dart';

class LiveChatController extends GetxController{
  var isLiveChatActive = false.obs;

  void  changeLiveChatState(){
    isLiveChatActive.value = !isLiveChatActive.value;
    print(isLiveChatActive.value);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}