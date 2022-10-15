import 'package:flutter/material.dart';
import 'package:quaily/src/common/utils/quailyUser.dart';
import 'package:quaily/src/features/friends/utils/addFriend.dart';
import 'package:quaily/src/features/friends/utils/customContact.dart';
import 'package:quaily/src/features/friends/utils/listUtils.dart';

class ContactListWidget extends StatefulWidget {
  @override
  ContactListWidgetState createState() => ContactListWidgetState();
}

class ContactListWidgetState extends State<ContactListWidget> {
  //TODO: Neuer Abschnitt für momentane Freundesanfragen
  //TODO: Freundesanfrage annehmen Funktionalität
  //TODO: Kontakte schon beim starten der App initialisieren im Hintergrund

  TextEditingController searchbarController = TextEditingController();
  ChangeNotifier userDataChanged = ChangeNotifier();
  late Widget userContactListWidget;
  late Widget nonUserContactListWidget;
  bool showUserList = true;
  bool showNonUserList = true;

  IconButton createAddContact(QuailyUser c) {
    return IconButton(
        icon: const Icon(Icons.person_add),
        onPressed: () {
          //Kontakt freundschaftsanfrage senden
          addContactAsFriend(c).then((value) => render());
        });
  }

  IconButton createInviteContact(Contact c) {
    return IconButton(
        icon: const Icon(Icons.mail),
        onPressed: () {
          //Kontakt zu Quaily einladen
          inviteContact(c);
        });
  }

  @override
  void initState() {
    super.initState();
    render();
    initContacts(userDataChanged);
    userDataChanged.addListener(() {
      render();
    });
    searchbarController.addListener(() {
      render();
    });
  }

  void render() {
    var userList = getUserContactList(filter: searchbarController.text);
    var nonUserList = getNonUserContactList(filter: searchbarController.text);

    setState(() {
      showUserList = userList.isNotEmpty;
      showNonUserList = nonUserList.isNotEmpty;

      userContactListWidget =
          getUserListWidget(userList, (c) => createAddContact(c));
      nonUserContactListWidget =
          getContactListWidget(nonUserList, (c) => createInviteContact(c));
    });
  }

  @override
  Widget build(Object context) {
    return Column(
      children: <Widget>[
        Container(
          height: 100,
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchbarController,
            decoration: InputDecoration(
              labelText: 'Search for Contact',
              border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(this.context).primaryColor),
              ),
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Visibility(
                  visible: showUserList,
                  child: Container(
                    color: Colors.grey,
                    alignment: Alignment.center,
                    height: 30,
                    child: Text('Kontakte auf Quaily: '),
                  ),
                ),
              ),
              userContactListWidget,
              SliverToBoxAdapter(
                child: Visibility(
                  visible: showNonUserList,
                  child: Container(
                    color: Colors.grey,
                    alignment: Alignment.center,
                    height: 30,
                    child: Text('Kontakte einladen: '),
                  ),
                ),
              ),
              nonUserContactListWidget,
            ],
          ),
        ),
      ],
    );
  }
}

Widget getContactListWidget(
    List<Contact> list, Widget Function(Contact c) iconButton) {
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      childCount: list.length,
      (BuildContext context, int index) {
        Contact? c = list.elementAt(index);
        return Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.blueGrey,
                width: 1,
              ),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.only(
                left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
            leading: (c.avatar != null && c.avatar!.isNotEmpty)
                ? CircleAvatar(backgroundImage: MemoryImage(c.avatar!))
                : CircleAvatar(
                    backgroundColor: c.getColor(),
                    child: Text(
                      c.initials(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
            title: Text(c.displayName ?? ""),
            trailing: iconButton(c),
          ),
        );
      },
    ),
  );
}

Widget getUserListWidget(
    List<QuailyUser> list, Widget Function(QuailyUser qu) iconButton) {
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      childCount: list.length,
      (BuildContext context, int index) {
        QuailyUser? qu = list.elementAt(index);
        return Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.blueGrey,
                width: 1,
              ),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.only(
                left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
            leading: CircleAvatar(backgroundImage: qu.avatar),
            title: Text(qu.displayname),
            trailing: iconButton(qu),
          ),
        );
      },
    ),
  );
}
