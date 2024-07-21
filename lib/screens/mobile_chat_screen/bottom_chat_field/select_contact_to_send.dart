import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:messaging/common/utils/colors.dart';
import 'package:messaging/common/utils/utils.dart';
import 'package:messaging/common/widgets/loader.dart';

class SelectContactToSend extends StatefulWidget {
  const SelectContactToSend({
    super.key,
  });

  @override
  State<SelectContactToSend> createState() => _SelectContactToSendState();
}

class _SelectContactToSendState extends State<SelectContactToSend> {
  Contact? selectedContact;
  Future<List<Contact>> getContact() async {
    List<Contact> allContactList = [];
    List<Contact> contacts = [];
    try {
      final bool isPermissionGranted =
          await FlutterContacts.requestPermission();
      if (isPermissionGranted) {
        allContactList = await FlutterContacts.getContacts(
          withProperties: true,
        );
        for (var contact in allContactList) {
          if (contact.phones.isNotEmpty) {
            contacts.add(contact);
          }
        }
      } else {
        await FlutterContacts.requestPermission();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select contact'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<Contact>>(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  physics: defaultScrollPhysics,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final contact = snapshot.data![index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedContact = contact;
                        });
                        Navigator.pop(context, selectedContact);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(
                            contact.displayName,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 18,
                            ),
                          ),
                          leading: contact.photo == null
                              ? const CircleAvatar(
                                  radius: 25,
                                  backgroundColor: lightGreenColor,
                                )
                              : CircleAvatar(
                                  radius: 25,
                                  backgroundImage: MemoryImage(contact.photo!),
                                ),
                        ),
                      ),
                    );
                  });
            } else {
              return Center(
                child: loader(radius: 20, color: lightTextColor),
              );
            }
          },
          future: getContact(),
        ),
      ),
    );
  }
}
