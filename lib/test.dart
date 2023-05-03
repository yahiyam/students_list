import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: Icon(Icons.add),
      title: Text('Header'),
      subtitle: Text('Subheading'),
    );
  }
}
