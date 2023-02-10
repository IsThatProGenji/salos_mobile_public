import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:salos/components/container.dart';
import 'package:intl/intl.dart';
import 'package:salos/components/container_outbound.dart';

mysqlsettings() {
  return ConnectionSettings(
      host: '******',
      port: ******,
      user: '******',
      db: '******',
      password: '******');
}

List<OpenContainerTransformDemo> _manifest = [];
List _outboundsDetail = [];
List<OpenContainerTransformDemo_outbound> _outbounds = [];
String password = '';
String companyID = '';
String usersID = '';
String companyName = '';
String companyUsername = '';
String companyEmail = '';
String sort = 'manifest_number';
String sort_outbound = 'connocement';

String searching = '';
String searching_outbound = '';
String searching_outbound_city = '';
String startDate = '';
String endDate = '';
String startDateOutbound = '';
String endDateOutbound = '';
FocusNode textfieldfocus = FocusNode();
FocusNode textfieldfocus_outbound = FocusNode();
bool loadingStatus = false;
bool noDataStatus = false;
String lazyStatus = 'false';
bool loadingStatusOutbound = false;
bool noDataStatusOutbound = false;
String lazyStatusOutbound = 'false';
bool loadingStatusLogin = false;

bool editMode = false;

String nameEdit = '';
String usernameEdit = '';
String emailEdit = '';
String passwordEdit = '';
String conPasswordEdit = '';

class Data extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  getFormatedDate(_date) {
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(_date);
    var outputFormat = DateFormat('dd-MM-yyyy HH:mm');
    return outputFormat.format(inputDate);
  }

  checkPassword(password, plainPassword) {
    // var hashedPassword = DBCrypt().hashpw(plainPassword, DBCrypt().gensalt());

    var isCorrect = DBCrypt().checkpw(plainPassword, password);

    // print(isCorrect);

    return isCorrect;
  }

  searchSQL() {
    return 'SELECT `u1825893_app`.`manifests`.id,manifest_number,manifest_date,name,remark FROM `u1825893_app`.`manifests`  join `u1825893_app`.`regencies` on   `u1825893_app`.`manifests`.regency_id =  `u1825893_app`.`regencies`.id WHERE (name like ? or manifest_date like ? or remark like ? or manifest_number like ?  )and company_id =$companyID  ORDER BY `u1825893_app`.`manifests`.id limit 2';
  }

  query(type) {
    var querys = '';
    if (type != 'search' && type != 'date') {
      querys =
          'SELECT `u1825893_app`.`manifests`.id,manifest_number,manifest_date,name,remark,company_id FROM `u1825893_app`.`manifests` JOIN `u1825893_app`.`regencies` ON  `u1825893_app`.`manifests`.regency_id =  `u1825893_app`.`regencies`.id AND company_id = "$companyId"  ORDER BY $sort,id Limit ${_manifest.length},${_manifest.length + 2} ';
    } else {
      if (type == 'date' && startDate != '') {
        querys =
            'SELECT `u1825893_app`.`manifests`.id,manifest_number,manifest_date,name,remark,company_id FROM `u1825893_app`.`manifests` JOIN `u1825893_app`.`regencies` ON  `u1825893_app`.`manifests`.regency_id =  `u1825893_app`.`regencies`.id AND company_id = "$companyId" WHERE manifest_date >= "$startDate" AND manifest_date <=  "$endDate" order by manifest_date Limit ${_manifest.length},${_manifest.length + 2}';
      }
    }
    return querys;
  }

  queryOutbound(type) {
    var querys = '';
    if (type != 'search' && type != 'date') {
      querys =
          """SELECT manifest_id,connocement,destination,sender_name,recipient_address,districts.`name`,
            kilo,koli,sender_address,r1.`name` as "Regency Sender",sender_phone,recipient_name,r2.`name` as "Regency Recipient",
            recipient_phone,tgl_entry,instruction,cost,packing_fee,services.`name`,origin,status   
            FROM outbounds JOIN districts on district_recipient_id = districts.id
            LEFT JOIN regencies r1 on regency_sender_id = r1.id
            LEFT JOIN regencies r2 on regency_recipient_id = r2.id
            JOIN services on service_id = services.id        
            WHERE 

            outbounds.company_id=${companyId.toString()} 
            
            ORDER by $sort_outbound,connocement
            limit ${_outbounds.length},${_outbounds.length + 2} """;
    } else {
      if (type == 'date' && startDateOutbound != '') {
        querys =
            """SELECT manifest_id,connocement,destination,sender_name,recipient_address,districts.`name`,
            kilo,koli,sender_address,r1.`name` as "Regency Sender",sender_phone,recipient_name,r2.`name` as "Regency Recipient",
            recipient_phone,tgl_entry,instruction,cost,packing_fee,services.`name`,origin,status   
            FROM outbounds JOIN districts on district_recipient_id = districts.id
            LEFT JOIN regencies r1 on regency_sender_id = r1.id
            LEFT JOIN regencies r2 on regency_recipient_id = r2.id
            JOIN services on service_id = services.id        
            WHERE 
            
            tgl_entry >=  "$startDateOutbound" AND tgl_entry  <= "$endDateOutbound" and

            outbounds.company_id=${companyId.toString()}

            order by tgl_entry
             
            limit ${_outbounds.length},${_outbounds.length + 2}""";
      }
    }
    if (type == 'search city') {
      querys =
          """SELECT manifest_id,connocement,destination,sender_name,recipient_address,districts.`name`,
            kilo,koli,sender_address,r1.`name` as "Regency Sender",sender_phone,recipient_name,r2.`name` as "Regency Recipient",
            recipient_phone,tgl_entry,instruction,cost,packing_fee,services.`name`,origin,status   
            FROM outbounds JOIN districts on district_recipient_id = districts.id
            LEFT JOIN regencies r1 on regency_sender_id = r1.id
            LEFT JOIN regencies r2 on regency_recipient_id = r2.id
            JOIN services on service_id = services.id        
            WHERE 

            
             r2.`name` = '$searching_outbound_city'
             
             and

            outbounds.company_id=${companyId.toString()}
             ORDER by connocement
            
             limit ${_outbounds.length},${_outbounds.length + 2}
             
            """;
    }
    return querys;
  }

  Future loginSql(plainPassword, username) async {
    bool loggedIn = false;
    loadingStatusLogin = true;
    _manifest = [];
    _outboundsDetail = [];
    _outbounds = [];
    notifyListeners();

    final conn = await MySqlConnection.connect(mysqlsettings());
    // Query the database using a parameterized query
    var results = await conn.query(
        'SELECT password,company_id,name,username,email,id FROM users WHERE username = ?',
        [username]);
    for (var row in results) {
      if (checkPassword(row[0].toString(), plainPassword) == true) {
        companyID = row[1].toString();
        companyName = row[2].toString();
        companyUsername = row[3].toString();
        companyEmail = row[4].toString();
        usersID = row[5].toString();
        // print('CompanyID =' + companyID);
        // print('CompanyName =' + companyName);
        // print('CompanyUsername =' + companyUsername);
        // print('CompanyEmail =' + companyEmail);
        // print('UsersID =' + usersID);
        loggedIn = true;
        conn.close;
      }
    }
    if (loggedIn == true) {
      await getSQLpre(companyId);
      await getSQLoutboundspre(companyId);
      await getSQLoutbounds_pre(companyId);
      saveUser();
    }

    loadingStatusLogin = false;
    notifyListeners();
    return loggedIn;
  }

  Future getSQLUsers(userid) async {
    final conn = await MySqlConnection.connect(mysqlsettings());
    // Query the database using a parameterized query
    usersID = userid;
    notifyListeners();
    var results = await conn.query(
        'SELECT password,company_id,name,username,email FROM users WHERE id = ?',
        [userid]);
    for (var row in results) {
      companyID = row[1].toString();
      companyName = row[2].toString();
      companyUsername = row[3].toString();
      companyEmail = row[4].toString();

      // print('CompanyID =' + companyID);
      // print('CompanyName =' + companyName);
      // print('CompanyUsername =' + companyUsername);
      // print('CompanyEmail =' + companyEmail);
    }
    notifyListeners();
  }

  Future getSQLpre(companyId) async {
    _manifest = [];
    _outboundsDetail = [];
    _outbounds = [];
    lazyStatus = 'false';
    noDataStatus = false;
    loadingStatus = true;
    notifyListeners();
    // print(loadingStatus);
    List<OpenContainerTransformDemo> data = [];
    final conn = await MySqlConnection.connect(mysqlsettings());
    companyID = companyId;
    // print(companyId);
    var results = await conn.query(
        'SELECT `u1825893_app`.`manifests`.id,manifest_number,manifest_date,name,remark,company_id FROM `u1825893_app`.`manifests` JOIN `u1825893_app`.`regencies` ON  `u1825893_app`.`manifests`.regency_id =  `u1825893_app`.`regencies`.id AND company_id = "$companyId"  ORDER BY $sort  Limit 2');
    for (var row in results) {
      data.add(OpenContainerTransformDemo(
        id: row[0],
        number: row[1].toString(),
        date: getFormatedDate(row[2].toString()),
        city: row[3].toString(),
        remark: row[4].toString(),
      ));

      // print(_manifest.toString());
    }
    conn.close;
    _manifest = data;

    loadingStatus = false;
    notifyListeners();
    // print(loadingStatus);
  }

  Future getSQLSort(sortby) async {
    lazyStatus = 'false';
    noDataStatus = false;
    loadingStatus = true;
    notifyListeners();
    String manifestid = '';
    List<OpenContainerTransformDemo> data = [];
    if (sortby == 'reset') {
      sort = 'manifest_number';
    } else if (sort == sortby) {
      sort = sortby += ' desc';
    } else {
      sort = sortby;
    }
    final conn = await MySqlConnection.connect(mysqlsettings());
    var results = await conn.query(
        'SELECT `u1825893_app`.`manifests`.id,manifest_number,manifest_date,name,remark,company_id FROM `u1825893_app`.`manifests` JOIN `u1825893_app`.`regencies` ON  `u1825893_app`.`manifests`.regency_id =  `u1825893_app`.`regencies`.id AND company_id = "$companyId"  ORDER BY $sort,id  Limit 2');
    for (var row in results) {
      data.add(OpenContainerTransformDemo(
        id: row[0],
        number: row[1].toString(),
        date: getFormatedDate(row[2].toString()),
        city: row[3].toString(),
        remark: row[4].toString(),
      ));
      manifestid += '${row[0].toString()},';
      // print(_manifest.toString());
    }
    conn.close;
    _manifest = data;
    List c = manifestid.split("");
    c.removeLast();
    getSQLoutboundsSort(c.join());
    loadingStatus = false;
    notifyListeners();
  }

  Future getSQLDate() async {
    lazyStatus = 'false';
    noDataStatus = false;
    loadingStatus = true;
    notifyListeners();
    String manifestid = '';
    List<OpenContainerTransformDemo> data = [];
    sort = 'date';
    final conn = await MySqlConnection.connect(mysqlsettings());
    var results = await conn.query(
        'SELECT `u1825893_app`.`manifests`.id,manifest_number,manifest_date,name,remark,company_id FROM `u1825893_app`.`manifests` JOIN `u1825893_app`.`regencies` ON  `u1825893_app`.`manifests`.regency_id =  `u1825893_app`.`regencies`.id AND company_id = "$companyId" WHERE manifest_date >=  "$startDate" AND manifest_date  <= "$endDate" order by manifest_date Limit 2');
    for (var row in results) {
      data.add(OpenContainerTransformDemo(
        id: row[0],
        number: row[1].toString(),
        date: getFormatedDate(row[2].toString()),
        city: row[3].toString(),
        remark: row[4].toString(),
      ));
      manifestid += '${row[0].toString()},';
      // print(_manifest.toString());
    }
    _manifest = data;
    loadingStatus = false;
    conn.close;
    notifyListeners();
    if (manifestid != '') {
      List c = manifestid.split("");
      c.removeLast();
      getSQLoutboundsSort(c.join());
      notifyListeners();
    } else {
      noDataStatus = true;
      notifyListeners();
    }
  }

  Future getSQLSearch(search) async {
    lazyStatus = 'false';
    noDataStatus = false;
    loadingStatus = true;
    notifyListeners();
    String manifestid = '';
    List<OpenContainerTransformDemo> data = [];
    sort = 'search';
    searching = '%' + search + '%';
    final conn = await MySqlConnection.connect(mysqlsettings());
    var results = await conn
        .query(searchSQL(), [searching, searching, searching, searching]);
    for (var row in results) {
      data.add(OpenContainerTransformDemo(
        id: row[0],
        number: row[1].toString(),
        date: getFormatedDate(row[2].toString()),
        city: row[3].toString(),
        remark: row[4].toString(),
      ));
      manifestid += '${row[0].toString()},';

      // print(_manifest.toString());
    }
    conn.close;
    loadingStatus = false;
    _manifest = data;
    notifyListeners();
    if (manifestid != '') {
      List c = manifestid.split("");
      c.removeLast();
      getSQLoutboundsSort(c.join());
    } else {
      noDataStatus = true;
      notifyListeners();
    }

    notifyListeners();
  }

  sqlLazySearchQuery() async {
    final conn = await MySqlConnection.connect(mysqlsettings());
    return conn.query(
        'SELECT `u1825893_app`.`manifests`.id,manifest_number,manifest_date,name,remark FROM `u1825893_app`.`manifests`  join `u1825893_app`.`regencies` on   `u1825893_app`.`manifests`.regency_id =  `u1825893_app`.`regencies`.id WHERE (name like ? or manifest_date like ? or remark like ? or manifest_number like ?)ORDER BY `u1825893_app`.`manifests`.id Limit ${_manifest.length},${_manifest.length + 2}',
        [
          searching,
          searching,
          searching,
          searching,
        ]);
  }

  Future getSQLlazy() async {
    if (lazyStatus != 'nodata') {
      lazyStatus = 'true';
      notifyListeners();
      String manifestid = '';
      final conn = await MySqlConnection.connect(mysqlsettings());
      var results = sort == 'search'
          ? await sqlLazySearchQuery()
          : await conn.query(query(sort));
      // print(query(sort));
      for (var row in results) {
        _manifest.add(OpenContainerTransformDemo(
          id: row[0],
          number: row[1].toString(),
          date: getFormatedDate(row[2].toString()),
          city: row[3].toString(),
          remark: row[4].toString(),
        ));
        manifestid += '${row[0].toString()},';
      }
      conn.close;
      // print(startDate);
      if (manifestid != '') {
        lazyStatus = 'false';
        List c = manifestid.split("");
        c.removeLast();
        getSQLoutboundsLazy(c.join());
        notifyListeners();
      } else {
        lazyStatus = 'nodata';
      }
      // print(_manifest.toString());

      notifyListeners();
    }
  }

  Future getSQLoutboundspre(companyId) async {
    final conn = await MySqlConnection.connect(mysqlsettings());
    var results = await conn.query(
        """ SELECT manifest_id,connocement,destination,sender_name,recipient_address,districts.`name`,
            kilo,koli,sender_address,r1.`name` as "Regency Sender",sender_phone,recipient_name,r2.`name` as "Regency Recipient",
            recipient_phone,tgl_entry,instruction,cost,packing_fee,services.`name`,origin   
            FROM outbounds JOIN districts on district_recipient_id = districts.id
            LEFT JOIN regencies r1 on regency_sender_id = r1.id
            LEFT JOIN regencies r2 on regency_recipient_id = r2.id
            JOIN services on service_id = services.id        
            WHERE manifest_id BETWEEN 1 and 2 AND 
            outbounds.company_id=${companyId.toString()}""");
    for (var row in results) {
      _outboundsDetail.add(
        {
          'id': row[0],
          'cn': row[1],
          'destination': row[2],
          'sender_name': row[3],
          'recipient_address': row[4],
          'recipient_district': row[5],
          'kilo': row[6],
          'koli': row[7],
          'sender_address': row[8],
          'sender_regency': row[9],
          'sender_phone': row[10],
          'recipient_name': row[11],
          'recipient_regency': row[12],
          'recipient_phone': row[13],
          'tgl_entry': getFormatedDate(row[14].toString()),
          'instruction': row[15],
          'cost': row[16],
          'packing_fee': row[17],
          'service': row[18],
          'origin': row[19],
        },
      );
    }
    conn.close;
    // print(_outboundsDetail.toString());
    notifyListeners();
    // print(_outboundsDetail.toString());
  }

  Future getSQLoutboundsSort(manifestID) async {
    List data = [];
    final conn = await MySqlConnection.connect(mysqlsettings());
    var results = await conn.query(
        """ SELECT manifest_id,connocement,destination,sender_name,recipient_address,districts.`name`,
            kilo,koli,sender_address,r1.`name` as "Regency Sender",sender_phone,recipient_name,r2.`name` as "Regency Recipient",
            recipient_phone,tgl_entry,instruction,cost,packing_fee,services.`name`  ,origin  
            FROM outbounds JOIN districts on district_recipient_id = districts.id
            LEFT JOIN regencies r1 on regency_sender_id = r1.id
            LEFT JOIN regencies r2 on regency_recipient_id = r2.id
            JOIN services on service_id = services.id  

        WHERE manifest_id in($manifestID) AND
        
         outbounds.company_id=${companyId.toString()}""");
    for (var row in results) {
      data.add(
        {
          'id': row[0],
          'cn': row[1],
          'destination': row[2],
          'sender_name': row[3],
          'recipient_address': row[4],
          'recipient_district': row[5],
          'kilo': row[6],
          'koli': row[7],
          'sender_address': row[8],
          'sender_regency': row[9],
          'sender_phone': row[10],
          'recipient_name': row[11],
          'recipient_regency': row[12],
          'recipient_phone': row[13],
          'tgl_entry': getFormatedDate(row[14].toString()),
          'instruction': row[15],
          'cost': row[16],
          'packing_fee': row[17],
          'service': row[18],
          'origin': row[19],
        },
      );
      conn.close;
      _outboundsDetail = data;
      // print(_outboundsDetail.toString());
    }
    notifyListeners();
    // print(_outboundsDetail.toString());
  }

  Future getSQLoutboundsLazy(manifestID) async {
    final conn = await MySqlConnection.connect(mysqlsettings());
    var results = await conn.query("""
            SELECT manifest_id,connocement,destination,sender_name,recipient_address,districts.`name`,
            kilo,koli,sender_address,r1.`name` as "Regency Sender",sender_phone,recipient_name,r2.`name` as "Regency Recipient",
            recipient_phone,tgl_entry,instruction,cost,packing_fee,services.`name`  ,origin  
            FROM outbounds JOIN districts on district_recipient_id = districts.id
            LEFT JOIN regencies r1 on regency_sender_id = r1.id
            LEFT JOIN regencies r2 on regency_recipient_id = r2.id
            JOIN services on service_id = services.id  

            WHERE manifest_id in($manifestID) 
            AND outbounds.company_id=${companyId.toString()}""");
    for (var row in results) {
      _outboundsDetail.add(
        {
          'id': row[0],
          'cn': row[1],
          'destination': row[2],
          'sender_name': row[3],
          'recipient_address': row[4],
          'recipient_district': row[5],
          'kilo': row[6],
          'koli': row[7],
          'sender_address': row[8],
          'sender_regency': row[9],
          'sender_phone': row[10],
          'recipient_name': row[11],
          'recipient_regency': row[12],
          'recipient_phone': row[13],
          'tgl_entry': getFormatedDate(row[14].toString()),
          'instruction': row[15],
          'cost': row[16],
          'packing_fee': row[17],
          'service': row[18],
          'origin': row[19],
        },
      );
      // print(_outboundsDetail.toString());
    }
    conn.close;
    notifyListeners();
    // print(_outboundsDetail.toString());
    // print(_outboundsDetail.toString());
  }

  void saveUser() async {
    usernameEdit = companyUsername;
    nameEdit = companyName;
    emailEdit = companyEmail;
    notifyListeners();
    final SharedPreferences prefs = await _prefs;
    // // Encode and store data in SharedPreferences
    await prefs.setString('companyID', companyID);
    await prefs.setString('usersID', usersID);
    await prefs.setString('isLoggedIns', 'true');
    await prefs.setString(
        'session', DateTime.now().add(Duration(days: 30)).toString());
  }

  void logout() async {
    _manifest = [];
    _outboundsDetail = [];
    _outbounds = [];
    password = '';
    companyID = '';
    companyName = '';
    sort = 'manifest_number';
    sort_outbound = 'connocement';
    startDate = '';
    endDate = '';
    startDateOutbound = '';
    endDateOutbound = '';
    notifyListeners();
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('companyID', companyID);
    await prefs.setString('usersID', usersID);
    await prefs.setString('session', '');
    // // Encode and store data in SharedPreferences
    await prefs.setString('isLoggedIns', 'false');
  }

  get manifestData {
    return _manifest;
  }

  get focus {
    return textfieldfocus;
  }

  void requestfocus() {
    textfieldfocus.requestFocus();
  }

  void disfocus() {
    textfieldfocus.unfocus();
  }

  get sortData {
    return sort;
  }

  get outboundData {
    return _outboundsDetail;
  }

  get outboundDatalength {
    return _outboundsDetail.length;
  }

  get manifestDataLength {
    return _manifest.length;
  }

  get companyId {
    return companyID;
  }

  void setStartDate(date) {
    startDate = date.toString();
    notifyListeners();
  }

  void setEndDate(date) {
    endDate = date.toString();
    notifyListeners();
  }

  get startDateData {
    return startDate;
  }

  get endDateData {
    return endDate;
  }

  get getoutbounds {
    return _outbounds;
  }

  get getoutboundslength {
    return _outbounds.length;
  }

  get sortDataoutbound {
    return sort_outbound;
  }

  get focus_outbound {
    return textfieldfocus_outbound;
  }

  void requestfocusoutbound() {
    textfieldfocus_outbound.requestFocus();
  }

  void disfocusoutbound() {
    textfieldfocus_outbound.unfocus();
  }

  void setStartDateOutbound(date) {
    startDateOutbound = date.toString();
    notifyListeners();
  }

  void setEndDateOutbound(date) {
    endDateOutbound = date.toString();
    notifyListeners();
  }

  get startDateDataOutbound {
    return startDateOutbound;
  }

  get endDateDataOutbound {
    return endDateOutbound;
  }

  get getloadingStatus {
    return loadingStatus;
  }

  get getNodataStatus {
    return noDataStatus;
  }

  get getLazyStatus {
    return lazyStatus;
  }

  get getloadingStatusOutbound {
    return loadingStatusOutbound;
  }

  get getNodataStatusOutbound {
    return noDataStatusOutbound;
  }

  get getLazyStatusOutbound {
    return lazyStatusOutbound;
  }

  get getLoadingStatusLogin {
    return loadingStatusLogin;
  }

  get getUsers {
    return {
      'id': companyID,
      'name': companyName,
      'username': companyUsername,
      'email': companyEmail
    };
  }

  get getEditMode {
    return editMode;
  }

  void toggleEditMode() {
    editMode = !editMode;
    notifyListeners();
  }

  get getNameEdit {
    return nameEdit;
  }

  void setNameEdit(name) {
    nameEdit = name;

    notifyListeners();
  }

  get getUsernameEdit {
    return usernameEdit;
  }

  void setUsernameEdit(username) {
    usernameEdit = username;
    // print(usernameEdit);
    notifyListeners();
  }

  get getEmailEdit {
    return emailEdit;
  }

  void setEmailEdit(email) {
    emailEdit = email;
    notifyListeners();
  }

  get getPasswordEdit {
    return passwordEdit;
  }

  void setPasswordEdit(pass) {
    passwordEdit = pass;
    notifyListeners();
  }

  get getConPasswordEdit {
    return conPasswordEdit;
  }

  void setConPasswordEdit(conpass) {
    conPasswordEdit = conpass;
    notifyListeners();
  }

  Future changeUserData() async {
    final conn = await MySqlConnection.connect(mysqlsettings());
    if (passwordEdit == '' && conPasswordEdit == '') {
      // print('edit');
      // print(usersID);
      conn.query("""
    UPDATE users
    SET name = ? , username= ?,
    email = ?
    WHERE id = ?;""", [nameEdit, usernameEdit, emailEdit, usersID]);
    } else if (passwordEdit != '' && conPasswordEdit != '') {
      // print('pass');
      var hashedPass = DBCrypt().hashpw(passwordEdit, DBCrypt().gensalt());

      conn.query("""
    UPDATE users
    SET name = ? , username= ?,
    email = ?,
    password = ?
    WHERE id = ?;""", [nameEdit, usernameEdit, emailEdit, hashedPass, usersID]);
    }

    var results = await conn
        .query('SELECT name,username,email FROM users WHERE id = ?', [usersID]);
    for (var row in results) {
      companyName = row[0].toString();
      companyUsername = row[1].toString();
      companyEmail = row[2].toString();
      // print('CompanyName =' + companyName);
      // print('CompanyUsername =' + companyUsername);
      // print('CompanyEmail =' + companyEmail);
      conn.close;
      usernameEdit = companyUsername;
      nameEdit = companyName;
      emailEdit = companyEmail;
    }

    conn.close;
    toggleEditMode();

    // print(_outboundsDetail.toString());
    notifyListeners();
    // print(_outboundsDetail.toString());
  }

  Future getSQLoutbounds_pre(companyId) async {
    lazyStatusOutbound = 'false';
    noDataStatusOutbound = false;
    loadingStatusOutbound = true;
    notifyListeners();
    List<OpenContainerTransformDemo_outbound> data = [];
    final conn = await MySqlConnection.connect(mysqlsettings());
    var results = await conn.query(
        """SELECT manifest_id,connocement,destination,sender_name,recipient_address,districts.`name`,
            kilo,koli,sender_address,r1.`name` as "Regency Sender",sender_phone,recipient_name,r2.`name` as "Regency Recipient",
            recipient_phone,tgl_entry,instruction,cost,packing_fee,services.`name`,origin,status   
            FROM outbounds JOIN districts on district_recipient_id = districts.id
            LEFT JOIN regencies r1 on regency_sender_id = r1.id
            LEFT JOIN regencies r2 on regency_recipient_id = r2.id
            JOIN services on service_id = services.id        
            WHERE 
            

            outbounds.company_id=${companyId.toString()} 
            ORDER by $sort_outbound 
            limit 5""");
    for (var row in results) {
      data.add(OpenContainerTransformDemo_outbound(
        id: row[0].toString(),
        cn: row[1].toString(),
        destination: row[2].toString(),
        sender_name: row[3].toString(),
        recipient_address: row[4].toString(),
        recipient_district: row[5].toString(),
        kilo: row[6].toString(),
        koli: row[7].toString(),
        sender_address: row[8].toString(),
        sender_regency: row[9].toString(),
        sender_phone: row[10].toString(),
        recipient_name: row[11].toString(),
        recipient_regency: row[12].toString(),
        recipient_phone: row[13].toString(),
        tgl_entry: getFormatedDate(row[14].toString()),
        instruction: row[15].toString(),
        cost: row[16].toString(),
        packing_fee: row[17].toString(),
        service: row[18].toString(),
        origin: row[19].toString(),
        status: row[20].toString(),
      ));

      // print(row[1]);
    }
    conn.close;
    _outbounds = data;
    loadingStatusOutbound = false;
    // print(_outboundsDetail.toString());
    notifyListeners();
    // print(_outboundsDetail.toString());
  }

  Future getSQLoutbounds_pre_sort(sortby) async {
    lazyStatusOutbound = 'false';
    noDataStatusOutbound = false;
    loadingStatusOutbound = true;
    notifyListeners();
    List<OpenContainerTransformDemo_outbound> data = [];

    if (sortby == 'reset') {
      sort_outbound = 'connocement';
    } else if (sort_outbound == sortby) {
      sort_outbound = sortby += ' desc';
    } else {
      sort_outbound = sortby;
    }

    final conn = await MySqlConnection.connect(mysqlsettings());
    var results = await conn.query(
        """SELECT manifest_id,connocement,destination,sender_name,recipient_address,districts.`name`,
            kilo,koli,sender_address,r1.`name` as "Regency Sender",sender_phone,recipient_name,r2.`name` as "Regency Recipient",
            recipient_phone,tgl_entry,instruction,cost,packing_fee,services.`name`,origin,status   
            FROM outbounds JOIN districts on district_recipient_id = districts.id
            LEFT JOIN regencies r1 on regency_sender_id = r1.id
            LEFT JOIN regencies r2 on regency_recipient_id = r2.id
            JOIN services on service_id = services.id        
            WHERE 

            outbounds.company_id=${companyId.toString()}
             ORDER by $sort_outbound,connocement
            
             limit 5""");
    for (var row in results) {
      data.add(OpenContainerTransformDemo_outbound(
        id: row[0].toString(),
        cn: row[1].toString(),
        destination: row[2].toString(),
        sender_name: row[3].toString(),
        recipient_address: row[4].toString(),
        recipient_district: row[5].toString(),
        kilo: row[6].toString(),
        koli: row[7].toString(),
        sender_address: row[8].toString(),
        sender_regency: row[9].toString(),
        sender_phone: row[10].toString(),
        recipient_name: row[11].toString(),
        recipient_regency: row[12].toString(),
        recipient_phone: row[13].toString(),
        tgl_entry: getFormatedDate(row[14].toString()),
        instruction: row[15].toString(),
        cost: row[16].toString(),
        packing_fee: row[17].toString(),
        service: row[18].toString(),
        origin: row[19].toString(),
        status: row[20].toString(),
      ));
    }
    conn.close;
    _outbounds = data;
    loadingStatusOutbound = false;
    // print(_outboundsDetail.toString());
    notifyListeners();
    // print(_outboundsDetail.toString());
  }

  Future getSQLoutbounds_pre_date() async {
    lazyStatusOutbound = 'false';
    noDataStatusOutbound = false;
    loadingStatusOutbound = true;
    notifyListeners();
    String manifestid = '';
    List<OpenContainerTransformDemo_outbound> data = [];
    sort_outbound = 'date';
    // print(sort_outbound);
    // print(endDateDataOutbound);
    final conn = await MySqlConnection.connect(mysqlsettings());
    var results = await conn.query(
        """SELECT manifest_id,connocement,destination,sender_name,recipient_address,districts.`name`,
            kilo,koli,sender_address,r1.`name` as "Regency Sender",sender_phone,recipient_name,r2.`name` as "Regency Recipient",
            recipient_phone,tgl_entry,instruction,cost,packing_fee,services.`name`,origin,status   
            FROM outbounds JOIN districts on district_recipient_id = districts.id
            LEFT JOIN regencies r1 on regency_sender_id = r1.id
            LEFT JOIN regencies r2 on regency_recipient_id = r2.id
            JOIN services on service_id = services.id        
            WHERE 
            
            tgl_entry >=  "$startDateOutbound" AND tgl_entry  <= "$endDateOutbound" and

            outbounds.company_id=${companyId.toString()}
             
            order by tgl_entry
             limit 5""");
    for (var row in results) {
      data.add(OpenContainerTransformDemo_outbound(
        id: row[0].toString(),
        cn: row[1].toString(),
        destination: row[2].toString(),
        sender_name: row[3].toString(),
        recipient_address: row[4].toString(),
        recipient_district: row[5].toString(),
        kilo: row[6].toString(),
        koli: row[7].toString(),
        sender_address: row[8].toString(),
        sender_regency: row[9].toString(),
        sender_phone: row[10].toString(),
        recipient_name: row[11].toString(),
        recipient_regency: row[12].toString(),
        recipient_phone: row[13].toString(),
        tgl_entry: getFormatedDate(row[14].toString()),
        instruction: row[15].toString(),
        cost: row[16].toString(),
        packing_fee: row[17].toString(),
        service: row[18].toString(),
        origin: row[19].toString(),
        status: row[20].toString(),
      ));
      manifestid += '${row[0].toString()},';
    }
    conn.close;
    _outbounds = data;
    loadingStatusOutbound = false;
    if (manifestid == '') {
      noDataStatusOutbound = true;
      notifyListeners();
    }
    // print(_outboundsDetail.toString());
    notifyListeners();
    // print(_outboundsDetail.toString());
  }

  Future getSQLoutbounds_pre_search(search) async {
    lazyStatusOutbound = 'false';
    noDataStatusOutbound = false;
    loadingStatusOutbound = true;
    String manifestid = '';
    List<OpenContainerTransformDemo_outbound> data = [];
    sort_outbound = 'search';
    searching_outbound = '%' + search + '%';
    final conn = await MySqlConnection.connect(mysqlsettings());
    var results = await conn.query(
        """SELECT manifest_id,connocement,destination,sender_name,recipient_address,districts.`name`,
            kilo,koli,sender_address,r1.`name` as "Regency Sender",sender_phone,recipient_name,r2.`name` as "Regency Recipient",
            recipient_phone,tgl_entry,instruction,cost,packing_fee,services.`name`,origin,status   
            FROM outbounds JOIN districts on district_recipient_id = districts.id
            LEFT JOIN regencies r1 on regency_sender_id = r1.id
            LEFT JOIN regencies r2 on regency_recipient_id = r2.id
            JOIN services on service_id = services.id        
            WHERE 

            (connocement like ? or
             tgl_entry like ? or 
             r1.`name` like ? or 
             r2.`name` like ? or
             status like ?
             )
             and

            outbounds.company_id=${companyId.toString()}
             ORDER by connocement
            
             limit 5""",
        [
          searching_outbound,
          searching_outbound,
          searching_outbound,
          searching_outbound,
          searching_outbound
        ]);
    for (var row in results) {
      data.add(OpenContainerTransformDemo_outbound(
        id: row[0].toString(),
        cn: row[1].toString(),
        destination: row[2].toString(),
        sender_name: row[3].toString(),
        recipient_address: row[4].toString(),
        recipient_district: row[5].toString(),
        kilo: row[6].toString(),
        koli: row[7].toString(),
        sender_address: row[8].toString(),
        sender_regency: row[9].toString(),
        sender_phone: row[10].toString(),
        recipient_name: row[11].toString(),
        recipient_regency: row[12].toString(),
        recipient_phone: row[13].toString(),
        tgl_entry: getFormatedDate(row[14].toString()),
        instruction: row[15].toString(),
        cost: row[16].toString(),
        packing_fee: row[17].toString(),
        service: row[18].toString(),
        origin: row[19].toString(),
        status: row[20].toString(),
      ));
      manifestid += '${row[0].toString()},';
    }
    conn.close;
    _outbounds = data;
    loadingStatusOutbound = false;

    if (manifestid == '') {
      noDataStatusOutbound = true;
      notifyListeners();
    }

    // print(_outboundsDetail.toString());
    notifyListeners();
  }

  Future getSQLoutbounds_pre_search_city(search) async {
    lazyStatusOutbound = 'false';
    noDataStatusOutbound = false;
    loadingStatusOutbound = true;
    String manifestid = '';
    List<OpenContainerTransformDemo_outbound> data = [];
    sort_outbound = 'search city';
    searching_outbound_city = '%' + search + '%';
    final conn = await MySqlConnection.connect(mysqlsettings());
    var results = await conn.query(
        """SELECT manifest_id,connocement,destination,sender_name,recipient_address,districts.`name`,
            kilo,koli,sender_address,r1.`name` as "Regency Sender",sender_phone,recipient_name,r2.`name` as "Regency Recipient",
            recipient_phone,tgl_entry,instruction,cost,packing_fee,services.`name`,origin,status   
            FROM outbounds JOIN districts on district_recipient_id = districts.id
            LEFT JOIN regencies r1 on regency_sender_id = r1.id
            LEFT JOIN regencies r2 on regency_recipient_id = r2.id
            JOIN services on service_id = services.id        
            WHERE 

            
             r2.`name` like ? 
            
             and

            outbounds.company_id=${companyId.toString()}
             ORDER by connocement
            
             limit 5""", [searching_outbound_city]);
    for (var row in results) {
      data.add(OpenContainerTransformDemo_outbound(
        id: row[0].toString(),
        cn: row[1].toString(),
        destination: row[2].toString(),
        sender_name: row[3].toString(),
        recipient_address: row[4].toString(),
        recipient_district: row[5].toString(),
        kilo: row[6].toString(),
        koli: row[7].toString(),
        sender_address: row[8].toString(),
        sender_regency: row[9].toString(),
        sender_phone: row[10].toString(),
        recipient_name: row[11].toString(),
        recipient_regency: row[12].toString(),
        recipient_phone: row[13].toString(),
        tgl_entry: getFormatedDate(row[14].toString()),
        instruction: row[15].toString(),
        cost: row[16].toString(),
        packing_fee: row[17].toString(),
        service: row[18].toString(),
        origin: row[19].toString(),
        status: row[20].toString(),
      ));
      manifestid += '${row[0].toString()},';
    }
    conn.close;
    _outbounds = data;
    loadingStatusOutbound = false;

    if (manifestid == '') {
      noDataStatusOutbound = true;
      notifyListeners();
    }

    // print(_outboundsDetail.toString());
    notifyListeners();
  }

  sqlOutbounsdSearchQuery() async {
    final conn = await MySqlConnection.connect(mysqlsettings());
    return conn.query(
        """SELECT manifest_id,connocement,destination,sender_name,recipient_address,districts.`name`,
            kilo,koli,sender_address,r1.`name` as "Regency Sender",sender_phone,recipient_name,r2.`name` as "Regency Recipient",
            recipient_phone,tgl_entry,instruction,cost,packing_fee,services.`name`,origin,status   
            FROM outbounds JOIN districts on district_recipient_id = districts.id
            LEFT JOIN regencies r1 on regency_sender_id = r1.id
            LEFT JOIN regencies r2 on regency_recipient_id = r2.id
            JOIN services on service_id = services.id        
            WHERE 

            (connocement like ? or
             tgl_entry like ? or 
             r1.`name` like ? or 
             r2.`name` like ? or
             status like ?
             )
             and

            outbounds.company_id=${companyId.toString()}
             ORDER by connocement
            
            limit ${_outbounds.length},${_outbounds.length + 2}""",
        [
          searching_outbound,
          searching_outbound,
          searching_outbound,
          searching_outbound,
          searching_outbound
        ]);
  }

  Future getSQLoutbounds_pre_lazy() async {
    if (lazyStatusOutbound != 'nodata') {
      lazyStatusOutbound = 'true';
      notifyListeners();
      String manifestid = '';
      // print('getting');
      final conn = await MySqlConnection.connect(mysqlsettings());
      var results = sort_outbound == 'search'
          ? await sqlOutbounsdSearchQuery()
          : await conn.query(queryOutbound(sort_outbound));
      for (var row in results) {
        _outbounds.add(OpenContainerTransformDemo_outbound(
          id: row[0].toString(),
          cn: row[1].toString(),
          destination: row[2].toString(),
          sender_name: row[3].toString(),
          recipient_address: row[4].toString(),
          recipient_district: row[5].toString(),
          kilo: row[6].toString(),
          koli: row[7].toString(),
          sender_address: row[8].toString(),
          sender_regency: row[9].toString(),
          sender_phone: row[10].toString(),
          recipient_name: row[11].toString(),
          recipient_regency: row[12].toString(),
          recipient_phone: row[13].toString(),
          tgl_entry: getFormatedDate(row[14].toString()),
          instruction: row[15].toString(),
          cost: row[16].toString(),
          packing_fee: row[17].toString(),
          service: row[18].toString(),
          origin: row[19].toString(),
          status: row[20].toString(),
        ));
        manifestid += '${row[0].toString()},';
      }
      conn.close;
      if (manifestid != '') {
        lazyStatusOutbound = 'false';
        notifyListeners();
      } else {
        lazyStatusOutbound = 'nodata';
        notifyListeners();
      }
      // print(_outboundsDetail.toString());
      notifyListeners();
    }

    // print(_outboundsDetail.toString());
  }
}
