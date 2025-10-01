import 'package:get/get.dart';

class SearchFilterController extends GetxController{
  RxString groupValue = "number".obs;

}

class SearchListController extends GetxController{
  RxMap searchResult = {}.obs;
}

class ObsecureController extends GetxController{
  RxBool obsecure = true.obs;
}