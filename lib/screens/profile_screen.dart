import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salos/components/profileTextForm.dart';
import 'package:provider/provider.dart';
import 'package:salos/components/scrollbehaviour.dart';
import 'package:salos/models/data.dart';
import 'package:salos/screens/login_page.dart';
import 'package:salos/components/constants.dart';
import 'package:salos/components/profileTextEditForm.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FocusNode nameFocusNode = FocusNode();
  FocusNode usernameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode conPasswordFocusNode = FocusNode();
  bool obscrureText = true;
  bool obscrureText2 = true;

  renderDialog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Row(
                children: const [
                  Icon(
                    Icons.error,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Unauthorize'),
                ],
              ),
              content: const Text('Password didn\'t match !'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              Provider.of<Data>(context).getEditMode
                  ? 'Edit Profile'
                  : 'Profile',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            actions: [
              Provider.of<Data>(context).getEditMode
                  ? TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        Provider.of<Data>(context, listen: false)
                            .toggleEditMode();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          Provider.of<Data>(context, listen: false).setNameEdit(
                              Provider.of<Data>(context, listen: false)
                                  .getUsers['name']);
                          Provider.of<Data>(context, listen: false)
                              .setUsernameEdit(
                                  Provider.of<Data>(context, listen: false)
                                      .getUsers['username']);
                          Provider.of<Data>(context, listen: false)
                              .setEmailEdit(
                                  Provider.of<Data>(context, listen: false)
                                      .getUsers['email']);
                          Provider.of<Data>(context, listen: false)
                              .setPasswordEdit('');
                          Provider.of<Data>(context, listen: false)
                              .setConPasswordEdit('');
                          Provider.of<Data>(context, listen: false)
                              .toggleEditMode();
                          nameFocusNode.requestFocus();
                        });
                      },
                      icon: const Icon(Icons.edit))
            ],
            elevation: 0,
            toolbarHeight: 45,
            backgroundColor: const Color(0xFF55BDD1),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Color(0xFF55BDD1),
                statusBarIconBrightness: Brightness.light)),
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView(
            children: [
              Provider.of<Data>(context).getEditMode
                  ? ProfileTextEditForm(
                      initial: Provider.of<Data>(context).getNameEdit,
                      onChanged:
                          Provider.of<Data>(context, listen: false).setNameEdit,
                      text: 'Name',
                      focusnode: nameFocusNode,
                      onSubmitted: () {
                        FocusScope.of(context).requestFocus(usernameFocusNode);
                      },
                    )
                  : ProfileTextForm(
                      title: 'Name',
                      text: Provider.of<Data>(context).getUsers['name']),
              Provider.of<Data>(context).getEditMode
                  ? ProfileTextEditForm(
                      onSubmitted: () {
                        FocusScope.of(context).requestFocus(emailFocusNode);
                      },
                      initial: Provider.of<Data>(context).getUsernameEdit,
                      onChanged: Provider.of<Data>(context, listen: false)
                          .setUsernameEdit,
                      text: 'Username',
                      focusnode: usernameFocusNode)
                  : ProfileTextForm(
                      title: 'Username',
                      text: Provider.of<Data>(context).getUsers['username']),
              Provider.of<Data>(context).getEditMode
                  ? ProfileTextEditForm(
                      onSubmitted: () {
                        FocusScope.of(context).requestFocus(passwordFocusNode);
                      },
                      initial: Provider.of<Data>(context).getEmailEdit,
                      onChanged: Provider.of<Data>(context, listen: false)
                          .setEmailEdit,
                      text: 'Email',
                      focusnode: emailFocusNode)
                  : ProfileTextForm(
                      title: 'Email',
                      text: Provider.of<Data>(context).getUsers['email']),
              Provider.of<Data>(context).getEditMode
                  ? Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 20, top: 20),
                              child: Text(
                                'Change Password',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff165b60)),
                              ),
                            ),
                            Container(
                                height: 50,
                                margin: const EdgeInsets.only(
                                    right: 20, left: 20, top: 5),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(85, 213, 234, 253),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        decoration: const BoxDecoration(),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                105,
                                        child: TextFormField(
                                            obscureText: obscrureText,
                                            initialValue:
                                                Provider.of<Data>(context)
                                                    .getPasswordEdit,
                                            focusNode: passwordFocusNode,
                                            decoration:
                                                kInputDecoration.copyWith(
                                                    hintText: '',
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                      left: 20,
                                                    )),
                                            style: const TextStyle(
                                                color: Color(0xff515466),
                                                fontSize: 14),
                                            onEditingComplete: () {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      conPasswordFocusNode);
                                            },
                                            onChanged: (value) {
                                              Provider.of<Data>(context,
                                                      listen: false)
                                                  .setPasswordEdit(value);
                                            })),
                                    Container(
                                      margin: const EdgeInsets.only(right: 3),
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: Material(
                                        shape: const CircleBorder(),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          onTap: () {
                                            setState(() {
                                              obscrureText = !obscrureText;
                                            });
                                          },
                                          child: Container(
                                            child: obscrureText
                                                ? const Icon(
                                                    Icons.visibility_off,
                                                  )
                                                : const Icon(
                                                    Icons.visibility,
                                                  ),
                                          ),
                                        ),
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 20, top: 20),
                              child: Text(
                                'Confirm Password',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff165b60)),
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(
                                    right: 20, left: 20, top: 5),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(85, 213, 234, 253),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(),
                                      height: 50,
                                      width: MediaQuery.of(context).size.width -
                                          105,
                                      child: TextFormField(
                                          obscureText: obscrureText2,
                                          initialValue:
                                              Provider.of<Data>(context)
                                                  .getConPasswordEdit,
                                          focusNode: conPasswordFocusNode,
                                          decoration: kInputDecoration.copyWith(
                                              hintText: '',
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                left: 20,
                                              )),
                                          style: const TextStyle(
                                              color: Color(0xff515466),
                                              fontSize: 14),
                                          onEditingComplete: () {
                                            conPasswordFocusNode.unfocus();
                                          },
                                          onChanged: (value) {
                                            Provider.of<Data>(context,
                                                    listen: false)
                                                .setConPasswordEdit(value);
                                          }),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 3),
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: Material(
                                        shape: const CircleBorder(),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          onTap: () {
                                            setState(() {
                                              obscrureText2 = !obscrureText2;
                                            });
                                          },
                                          child: Container(
                                            child: obscrureText2
                                                ? const Icon(
                                                    Icons.visibility_off,
                                                  )
                                                : const Icon(
                                                    Icons.visibility,
                                                  ),
                                          ),
                                        ),
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              Provider.of<Data>(context).getEditMode
                  ? Provider.of<Data>(context).getNameEdit != '' &&
                              Provider.of<Data>(context).getEmailEdit != '' &&
                              Provider.of<Data>(context).getUsernameEdit !=
                                  '' &&
                              Provider.of<Data>(context).getConPasswordEdit ==
                                  '' &&
                              Provider.of<Data>(context).getPasswordEdit ==
                                  '' ||
                          Provider.of<Data>(context).getNameEdit != '' &&
                              Provider.of<Data>(context).getEmailEdit != '' &&
                              Provider.of<Data>(context).getUsernameEdit !=
                                  '' &&
                              Provider.of<Data>(context).getConPasswordEdit !=
                                  '' &&
                              Provider.of<Data>(context).getPasswordEdit != ''
                      ? Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: GestureDetector(
                            onTap: () {
                              Provider.of<Data>(context, listen: false)
                                          .getPasswordEdit ==
                                      Provider.of<Data>(context, listen: false)
                                          .getConPasswordEdit
                                  ? Provider.of<Data>(context, listen: false)
                                      .changeUserData()
                                      .then((value) => ScaffoldMessenger.of(
                                              context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Success change profile data'))))
                                  : renderDialog();
                            },
                            child: Container(
                                margin: const EdgeInsets.only(
                                    right: 20, left: 20, top: 25),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: kMainBlue,
                                ),
                                height: 48,
                                width: double.infinity,
                                child: const Center(
                                  child: Text(
                                    'Confirm',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                                margin: const EdgeInsets.only(
                                    right: 20, left: 20, top: 25),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: kMainBluelight),
                                height: 48,
                                width: double.infinity,
                                child: const Center(
                                  child: Text(
                                    'Confirm',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                          ),
                        )
                  : Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.id);
                          Provider.of<Data>(context, listen: false).logout();
                        },
                        child: Container(
                            margin: const EdgeInsets.only(
                                right: 20, left: 20, top: 25),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xffd9214e),
                            ),
                            height: 48,
                            width: double.infinity,
                            child: const Center(
                              child: Text(
                                'Log Out',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            )),
                      ),
                    ),
            ],
          ),
        ));
  }
}
