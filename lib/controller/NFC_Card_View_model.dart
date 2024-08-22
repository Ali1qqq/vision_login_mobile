

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/models/NFC_Card_Model.dart';

import '../constants.dart';

class NfcCardViewModel extends GetxController {
  final nfcCardCollectionRef = FirebaseFirestore.instance.collection(nfcCardCollection);

  NfcCardViewModel() {
    getAllNfcCard();

    /// this for add card from Local const to Firebase
 /*   cardsMap.forEach(
      (key, value) {
        addNfcCard(NfcCardModel(nfcId: key, nfcUid: value));
      },
    );*/
  }

  Map<String, NfcCardModel> _nfcCardMap = {};

  Map<String, NfcCardModel> get nfcCardMap => _nfcCardMap;

  getAllNfcCard() async {
    await nfcCardCollectionRef.snapshots().listen(
      (value) {
        for (var element in value.docs) {
          _nfcCardMap[element.id] = NfcCardModel.fromJson(element.data());
        }
        // print(_nfcCardMap.values.map((e) => e.toJson(),).toList());
        // print(_nfcCardMap.keys.toList());
        update();
      },

    );

  }

  setCardForEMP( String cardId,String userId) async {

  String? cardUid=  nfcCardMap.entries.where((element) => element.value.nfcId==cardId,).first.key;

    await nfcCardCollectionRef.doc(cardUid).set(NfcCardModel(userId: userId).toJson(), SetOptions(merge: true));
    getAllNfcCard();
    update();
  }

  addNfcCard(NfcCardModel model) async {
    await nfcCardCollectionRef.doc(model.nfcUid).set(model.toJson(),SetOptions(merge: true));
  }

   deleteUserCard(String? cardId)async {
     print(cardId);
     String? cardUid=  nfcCardMap.entries.where((element) => element.value.nfcId==cardId,).first.key;
     print(cardUid);
     await nfcCardCollectionRef.doc(cardUid).set(NfcCardModel(userId:"").toJson(), SetOptions(merge: true));
    getAllNfcCard();
    update();
  }
}
