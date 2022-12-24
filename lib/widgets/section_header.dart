import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title, action;
  final Function btnClicked;
  const SectionHeader(
      {Key? key,
      required this.title,
      this.action = 'View more',
      required this.btnClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      TextButton(
          onPressed: () {
            btnClicked();
          },
          child: Text(
            action,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.white),
          ))
    ]);
  }
}
