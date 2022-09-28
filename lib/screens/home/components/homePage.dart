import 'package:flutter/material.dart';

import 'package:quaily/components/quailyAppBar.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _title = 'Quaily.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: QuailyAppBar(
          IconButton(
            iconSize: 32.0,
            onPressed: () => Navigator.pushNamed(context, '/friends'),
            icon: const Icon(
              Icons.person_add,
            ),
          ),
          _title,
          Container(
            padding: const EdgeInsets.all(4.0),
            child: Material(
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: Ink.image(
                image: const AssetImage('assets/default_profile.png'),
                fit: BoxFit.cover,
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
