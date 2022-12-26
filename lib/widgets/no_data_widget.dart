import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  const NoData({Key? key, required this.title, required this.message})
      : super(key: key);
  final String title, message;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.brown.shade400,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
            const Divider(
              color: Colors.white,
            ),
            Text(message),
          ],
        ),
      ),
    );
  }
}
