import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:messaging/data/data_source/select_contact_data_source.dart';
import 'package:messaging/models/user_model.dart';

final SelectContactRepository selectContactRepository = SelectContactRepository(
    dataSource:
        SelectContactFirebaseDataSource(firestore: FirebaseFirestore.instance));

abstract class ISelectContactRepository {
  Future<UserModel?> selectContact(Contact selectedContact);
}

class SelectContactRepository implements ISelectContactRepository {
  final ISelectContactDataSource dataSource;

  SelectContactRepository({required this.dataSource});
  @override
  Future<UserModel?> selectContact(Contact selectedContact) async {
    return await dataSource.selectContact(selectedContact);
  }
}
