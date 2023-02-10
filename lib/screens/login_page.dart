import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salos/components/constants.dart';
import 'package:salos/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:salos/models/data.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode textfield = FocusNode();
  FocusNode textfield2 = FocusNode();
  bool obscrureText = true;
  String username = '';
  String plainPassword = '';
  String password = 'false';
  String companyID = 'false';
  String companyName = 'false';
  List manifest = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textfield.dispose();
    textfield2.dispose();
    super.dispose();
  }

  renderColor() {
    Color couulour = Color.fromARGB(255, 145, 228, 245);
    if (plainPassword != '' && username != '') {
      couulour = kMainBlue;
    }

    return couulour;
  }

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
              content:
                  const Text('These credentials do not match our records.'),
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
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.white,
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          left: 30,
          right: 30,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width - 105,
                child: Image.asset('images/salos_logo.png')),
            const SizedBox(
              height: 25.0,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: Colors.grey.shade400,
                ),
              ),
              child: TextField(
                  focusNode: textfield,
                  style: const TextStyle(color: Colors.black),
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                  onSubmitted: (val) {
                    FocusScope.of(context).requestFocus(textfield2);
                  },
                  decoration: kInputDecoration.copyWith(
                      hintText: 'Username',
                      contentPadding: const EdgeInsets.only(left: 20))),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey.shade400,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 105,
                      child: TextField(
                          focusNode: textfield2,
                          style: const TextStyle(color: Colors.black),
                          obscureText: obscrureText,
                          onChanged: (value) {
                            setState(() {
                              plainPassword = value;
                            });
                          },
                          onSubmitted: (val) async {
                            textfield.unfocus();
                            textfield2.unfocus();
                            plainPassword != '' && username != ''
                                ? await Provider.of<Data>(context,
                                        listen: false)
                                    .loginSql(plainPassword, username)
                                    .then((value) => value == true
                                        ? Navigator.pushReplacementNamed(
                                            context, HomeScreen.id)
                                        : renderDialog())
                                : () {};
                          },
                          decoration: kInputDecoration.copyWith(
                              hintText: 'Password',
                              contentPadding: const EdgeInsets.only(left: 20))),
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
                        child: new InkWell(
                          borderRadius: BorderRadius.circular(25.0),
                          onTap: () {
                            setState(() {
                              obscrureText = !obscrureText;
                            });
                          },
                          child: new Container(
                            child: obscrureText
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                          ),
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                )),
            const SizedBox(
              height: 15.0,
            ),
            Material(
              color: renderColor(),
              borderRadius: BorderRadius.circular(5),
              child: GestureDetector(
                onTap: Provider.of<Data>(context).getLoadingStatusLogin
                    ? () {}
                    : plainPassword != '' && username != ''
                        ? () async {
                            textfield.unfocus();
                            textfield2.unfocus();
                            await Provider.of<Data>(context, listen: false)
                                .loginSql(plainPassword, username)
                                .then((value) => value == true
                                    ? Navigator.pushReplacementNamed(
                                        context, HomeScreen.id)
                                    : renderDialog());
                            // if (Provider.of<Data>(context, listen: false).login == true) {
                            //   Navigator.pushReplacementNamed(context, HomeScreen.id);
                            // }
                          }
                        : (() {}),
                child: Provider.of<Data>(context).getLoadingStatusLogin
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)),
                        height: 48,
                        width: double.infinity,
                        child: const Center(
                            child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )))
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: renderColor(),
                        ),
                        height: 48,
                        width: double.infinity,
                        child: const Center(
                          child: Text(
                            'Log In',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
