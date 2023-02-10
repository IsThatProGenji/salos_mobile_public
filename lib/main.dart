import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/login_page.dart';
import 'models/data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home.dart';
import 'package:flutter/services.dart';

late String initialRoute;
var id;
var usersID;
var session;
var dt1;
var dt2;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init a shared preferences variable
  SharedPreferences prefs = await SharedPreferences.getInstance();
  id = prefs.getString('companyID');
  usersID = prefs.getString('usersID');
  session = prefs.getString('session');
  // get the locally stored boolean variable
  if (session != null && session != '') {
    dt1 = DateTime.parse(session);
    dt2 = DateTime.now();
  } else {
    dt1 = '';
    dt2 = '';
  }

  print(dt2);
  print(dt1);
  // print(isLoggedIn);
  if (id != null &&
      usersID != null &&
      id != '' &&
      usersID != '' &&
      session != null &&
      session != '' &&
      dt1.compareTo(dt2) > 0) {
    initialRoute = HomeScreen.id;
  } else {
    initialRoute = LoginScreen.id;
  }
  // print(initialRoute);

  runApp(ChangeNotifierProvider(
      create: (context) => Data(), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final int _blackPrimaryValue = 0xff165b60;

  static const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xffF6F8FA),
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Color(0xffF6F8FA),
  );

  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(overlayStyle);
      fetchdata();
    });
  }

  fetchdata() async {
    if (initialRoute == HomeScreen.id &&
        id != null &&
        usersID != null &&
        id != '' &&
        usersID != '') {
      await Provider.of<Data>(context, listen: false).getSQLpre(id);
      await Provider.of<Data>(context, listen: false).getSQLoutboundspre(id);
      await Provider.of<Data>(context, listen: false).getSQLoutbounds_pre(id);
      await Provider.of<Data>(context, listen: false).getSQLUsers(usersID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        backgroundColor: Colors.blueGrey,
        primarySwatch: MaterialColor(
          _blackPrimaryValue,
          const <int, Color>{
            50: Color(0xff165b60),
            100: Color(0xff165b60),
            200: Color(0xff165b60),
            300: Color(0xff165b60),
            400: Color(0xff165b60),
            500: Color(0xff165b60),
            600: Color(0xff165b60),
            700: Color(0xff165b60),
            800: Color(0xff165b60),
            900: Color(0xff165b60),
          },
        ),
        scaffoldBackgroundColor: const Color(0xffF6F8FA),
      ),
      initialRoute: initialRoute,
      routes: {
        LoginScreen.id: (context) => const LoginScreen(),
        HomeScreen.id: (context) => const HomeScreen()
      },
    );
  }
}
