import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:provider/provider.dart';
import 'package:salos/models/data.dart';

class ProfileTextEditForm extends StatelessWidget {
  ProfileTextEditForm(
      {required this.initial,
      required this.onChanged,
      required this.text,
      required this.focusnode,
      required this.onSubmitted});
  FocusNode focusnode;
  String initial;
  var onChanged;
  var onSubmitted;
  String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Color(0xff165b60)),
                ),
                initial == ''
                    ? Text(
                        '*required',
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          Container(
              height: 50,
              padding: EdgeInsets.only(top: 2),
              margin: EdgeInsets.only(right: 20, left: 20, top: 5),
              decoration: BoxDecoration(
                color: Color.fromARGB(85, 213, 234, 253),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextFormField(
                initialValue: initial,
                focusNode: focusnode,
                decoration: kInputDecoration.copyWith(
                    hintText: '',
                    contentPadding: EdgeInsets.only(
                      left: 20,
                    )),
                style: const TextStyle(color: Color(0xff515466), fontSize: 14),
                onEditingComplete: onSubmitted,
                onChanged: (value) {
                  onChanged(value);
                },
              )),
        ],
      ),
    );
  }
}
