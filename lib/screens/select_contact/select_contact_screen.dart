import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:messaging/common/utils/colors.dart';
import 'package:messaging/common/utils/utils.dart';
import 'package:messaging/common/widgets/loader.dart';
import 'package:messaging/data/repository/select_contact_repository.dart';
import 'package:messaging/models/user_model.dart';
import 'package:messaging/screens/mobile_chat_screen/mobile_chat_screen.dart';
import 'package:messaging/screens/select_contact/bloc/select_contact_bloc.dart';

class SelectContactScreen extends StatefulWidget {
   final File defaultWallpaperFile;
  final UserModel userModel;
  const SelectContactScreen(
      {super.key, required this.userModel, required this.defaultWallpaperFile});

  @override
  State<SelectContactScreen> createState() => _SelectContactScreenState();
}

class _SelectContactScreenState extends State<SelectContactScreen> {
  late StreamSubscription<SelectContactState>? stateSubscription;

  TextEditingController textEditingController = TextEditingController();
  bool isShowSerachBar = false;

  @override
  void dispose() {
    stateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select contact'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isShowSerachBar = !isShowSerachBar;
              });
            },
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
          child: BlocProvider<SelectContactBloc>(
        create: (context) {
          final bloc = SelectContactBloc(
              selectContactRepository: selectContactRepository);
          stateSubscription = bloc.stream.listen((state) {
            if (state is SelectContactSuccess) {
              Navigator.of(context)
                ..pop()
                ..push(MaterialPageRoute(builder: (context) {
                  return MobileChatScreen(
                    contactUserModel: state.contactUserModel,
                    userModel: widget.userModel, defaultWallpaperFile: widget.defaultWallpaperFile,
       
                  );
                }));
            }
          });
          return bloc;
        },
        child: FutureBuilder<List<Contact>>(
          future: getContact(searchTerm: textEditingController.text),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  isShowSerachBar
                      ? Container(
                          padding: const EdgeInsets.all(20),
                          height: 100,
                          child: TextField(
                            onChanged: (searchTerm) {
                              setState(() {});
                            },
                            controller: textEditingController,
                            decoration: InputDecoration(
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(color: Colors.black38),
                              hintText: 'Serach name ...',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:
                                      const BorderSide(color: lightGreenColor)),
                            ),
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: ListView.builder(
                        physics: defaultScrollPhysics,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final contact = snapshot.data![index];
                          return InkWell(
                              onTap: () {
                                BlocProvider.of<SelectContactBloc>(context).add(
                                    SelectContactStarted(
                                        selectedContact: contact));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 4, top: 4),
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
                                          backgroundImage:
                                              MemoryImage(contact.photo!),
                                        ),
                                ),
                              ));
                        }),
                  ),
                ],
              );
            } else {
              return Center(
                child: loader(radius: 20, color: lightAppBarColor),
              );
            }
          },
        ),
      )),
    );
  }
}
