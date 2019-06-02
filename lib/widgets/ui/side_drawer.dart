import 'package:flash_it/controllers/google_services_api.dart';
import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  final int active;
  final List<List> itemDetails = [
    ['Home', Icons.home, 0],
    ['Settings', Icons.settings, 1],
    ['About', Icons.info, 2],
  ];

  SideDrawer(this.active);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    children.add(UserAccountsDrawerHeader(
      accountEmail: Text(GoogleServicesAPI.gService.email),
      accountName: Text(
        GoogleServicesAPI.gService.userName,
        style: Theme.of(context).textTheme.title.copyWith(
              color: Colors.white,
            ),
      ),
      currentAccountPicture: CircleAvatar(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(GoogleServicesAPI.gService.photoURL),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    ));

    children.addAll(itemDetails.map((List e) {
      bool selected = active == e[2];
      return ListTile(
        title: Text(e[0],
            style: Theme.of(context).textTheme.body1.copyWith(
                color:
                    selected ? Theme.of(context).primaryColor : Colors.black)),
        leading: Icon(e[1]),
        onTap: () => selected == false
            ? Navigator.pushReplacementNamed(
                context, e[0].toString().toLowerCase())
            : null,
        selected: selected,
      );
    }).toList());

    return Drawer(child: ListView(children: children));
  }
}
