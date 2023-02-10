import 'package:flutter/material.dart';

class ProfileTextForm extends StatelessWidget {
  ProfileTextForm({
    Key? key,
    required this.title,
    required this.text,
  }) : super(key: key);

  String title;

  String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Color(0xff165b60)),
          ),
        ),
        Container(
            padding: const EdgeInsets.only(left: 20),
            width: double.infinity,
            margin: const EdgeInsets.only(right: 20, left: 20, top: 5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(85, 213, 234, 253),
              borderRadius: BorderRadius.circular(5),
            ),
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(color: Color(0xff515466)),
                ),
              ],
            )),
      ],
    );
  }
}
