String generateChatId({required String uid1,required String uid2}){
  List<String> ids = [uid1, uid2]..sort();
  return "${ids[0]}_${ids[1]}";
}