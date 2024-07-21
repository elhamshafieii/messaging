import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:messaging/common/utils/colors.dart';
import 'package:messaging/common/utils/utils.dart';

class ViewContact extends StatelessWidget {
  final Map<String, dynamic> selectedContact;
  const ViewContact({super.key, required this.selectedContact});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Contact'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'assets/images/profile_image_backgroung.png',
                  width: 60,
                  height: 60,
                )),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Text(
                selectedContact['displayName'],
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(color: Color.fromARGB(255, 25, 116, 190)),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Contact contact = Contact.fromJson(selectedContact);
                contact.id = '';
                try {
                  await contact.insert();
                     if (context.mounted) {
                       showSnackBar(
                      context: context,
                      content: 'Contact was added to contact list ...');
                     }
                } catch (e) {
                   if (context.mounted) {
                     showSnackBar(
                      context: context,
                      content: 'This contact exists in contact list ...');
                   }
                }
              },
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(tabColor),
                  foregroundColor: WidgetStateProperty.all(Colors.white)),
              child: const Text('Add'),
            )
          ],
        ),
      ),
    );
  }
}
