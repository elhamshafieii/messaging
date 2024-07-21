import 'package:flutter/material.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:messaging/common/utils/utils.dart';
import 'package:messaging/models/user_model.dart';
import 'package:messaging/screens/mobile_chat_screen/widgets/contact_image_display.dart';

class ContactDetailScreen extends StatelessWidget {
  final UserModel contactUserModel;

  const ContactDetailScreen({super.key, required this.contactUserModel});
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: defaultScrollPhysics,
          slivers: [
            SliverAppBar(
                automaticallyImplyLeading: true,
                foregroundColor: Colors.black,
                expandedHeight: 200,
                backgroundColor: Colors.white,
                flexibleSpace: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    contactUserModel.profilePic != ''
                        ? FutureBuilder(
                            future: DefaultCacheManager()
                                .getSingleFile(contactUserModel.profilePic!),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                return GestureDetector(
                                  onTap: () async {
                                    navigateToOtherScreen(
                                        context,
                                        ContactImageDisplay(
                                          imageFile: snapshot.data,
                                          contactName: contactUserModel.name,
                                        ));
                                  },
                                  child: CircleAvatar(
                                    radius: 80,
                                    backgroundImage: FileImage(snapshot.data),
                                  ),
                                );
                              } else {
                                return CircleAvatar(
                                  radius: 80,
                                  backgroundImage: Image.asset(
                                          'assets/images/profile_image_backgroung.png')
                                      .image,
                                );
                              }
                            },
                          )
                        : CircleAvatar(
                            radius: 80,
                            backgroundImage: Image.asset(
                                    'assets/images/profile_image_backgroung.png')
                                .image,
                          ),
                  ],
                )),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Text(
                    contactUserModel.name,
                    style: themeData.textTheme.headlineMedium!
                        .copyWith(color: themeData.primaryColor),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    contactUserModel.phoneNumber,
                    style: themeData.textTheme.headlineSmall!.copyWith(
                        color: themeData.primaryColor.withOpacity(0.5)),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      'Last seen  ....',
                      style: themeData.textTheme.bodyMedium!.copyWith(
                          color: themeData.appBarTheme.backgroundColor),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Item(
                        themeData: themeData,
                        iconData: Icons.phone,
                        title: 'Audio',
                      ),
                      Item(
                        themeData: themeData,
                        iconData: Icons.video_call,
                        title: 'Video',
                      ),
                      Item(
                        themeData: themeData,
                        iconData: Icons.search,
                        title: 'Search',
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey.shade300,
                          Colors.white,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Text(
                    'Hey there, I am using Messaging',
                    style: themeData.textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 18,
                  ),     Container(
                    height: 8,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey.shade300,
                          Colors.white,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final IconData iconData;
  final String title;
  const Item({
    super.key,
    required this.themeData,
    required this.iconData,
    required this.title,
  });

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return InkWell(borderRadius: BorderRadius.circular(12),
      onTap: () {
      
    },
      child: Container(
        padding: const EdgeInsets.fromLTRB(32, 12, 32, 12),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade400,
            ),
            borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Column(
            children: [
              Icon(iconData, color: themeData.colorScheme.primary),
              const SizedBox(
                height: 8,
              ),
              Text(
                title,
                style: themeData.textTheme.bodySmall!
                    .copyWith(color: themeData.appBarTheme.backgroundColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
