import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_master/components/auth/services/auth_service.dart';
import 'package:uuid/uuid.dart';

class StorageMethod {
  final FirebaseStorage storage = FirebaseStorage.instance;
  WidgetRef? reff;
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost, WidgetRef ref) async {
    var auth = ref.read(userProvider);
    Reference reff = storage.ref().child(childName).child(auth.id);

    if (isPost) {
      String id = const Uuid().v1();
      reff = reff.child(id);
    }

    UploadTask uploadTask = reff.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
