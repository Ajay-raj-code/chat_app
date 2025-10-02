import 'package:intl/intl.dart';

String generateChatId({required String uid1,required String uid2}){
  List<String> ids = [uid1, uid2]..sort();
  return "${ids[0]}_${ids[1]}";
}

String convertTime({required int time}){
  final DateTime date = DateTime.fromMillisecondsSinceEpoch(time, isUtc: true).toLocal();

  return DateFormat('hh:mm a').format(date).toString();
}