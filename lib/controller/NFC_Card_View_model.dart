

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/models/NFC_Card_Model.dart';

import '../constants.dart';

class NfcCardViewModel extends GetxController {
  final nfcCardCollectionRef = FirebaseFirestore.instance.collection(nfcCardCollection);

  NfcCardViewModel() {
    getAllNfcCard();

    /// this for add card from Local const to Firebase
   /* cardsMap.forEach(
      (key, value) {
        addNfcCard(NfcCardModel(nfcId: key, nfcUid: value));
      },
    );*/
  }

  Map<String, NfcCardModel> _nfcCardMap = {};

  Map<String, NfcCardModel> get nfcCardMap => _nfcCardMap;

  getAllNfcCard() async {
    await nfcCardCollectionRef.get().then(
      (value) {
        for (var element in value.docs) {
          _nfcCardMap[element.id] = NfcCardModel.fromJson(element.data());
        }
      },
    );
    update();
  }

  setCardForEMP(String cardId, String userId) async {
    await nfcCardCollectionRef.doc(cardId).set(NfcCardModel(userId: userId, nfcId: cardId).toJson(), SetOptions(merge: true));
    getAllNfcCard();
    update();
  }

  addNfcCard(NfcCardModel model) async {
    await nfcCardCollectionRef.doc(model.nfcId).set(model.toJson(),SetOptions(merge: true));
  }

   deleteUserCard(String? cardId)async {
    await nfcCardCollectionRef.doc(cardId).set(NfcCardModel(userId: null, nfcId: cardId).toJson(), SetOptions(merge: true));
    getAllNfcCard();
    update();
  }
}
