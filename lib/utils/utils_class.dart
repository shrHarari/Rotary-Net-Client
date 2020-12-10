import 'dart:io';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:uuid/uuid.dart';import 'package:connectivity/connectivity.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

class Utils {

  //#region Check Connection
  // =============================================================================
  static Future checkConnection() async{
    ConnectivityResult _connectivity;
    try {
      Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        _connectivity = result;
      });

      if (_connectivity != ConnectivityResult.none) {
        print('<Utils> Check Connection >>> OK');
        await LoggerService.log('<Utils> Check Connection >>> OK');
        return true;
      } else {
        print('<Utils> Check Connection >>> Failed >>> $_connectivity');
        await LoggerService.log('<Utils> Check Connection >>> Failed >>> $_connectivity');
        return false;
      }
    }
    catch  (e) {
      print('<Utils> Check Connection >>> ERROR: ${e.toString()}');
      await LoggerService.log('<Utils> Check Connection >>> ERROR: ${e.toString()}');
      developer.log(
        'checkConnection',
        name: 'Utils',
        error: 'Check Connection >>> ERROR: ${e.toString()}',
      );
      return false;
    }
  }
  //#endregion

  //#region Application Documents Path
  static Future<String> get applicationDocumentsPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  //#endregion

  //#region Create Directory In App Doc Dir
  static Future<String> createDirectoryInAppDocDir(String aDirectoryName) async {
    //Get this App Document Directory
    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    //App Document Directory + folder name
    final Directory _appDocDirFolder =  Directory('${_appDocDir.path}/$aDirectoryName');

    if(await _appDocDirFolder.exists())
    {
      //if folder already exists return path
      return _appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder = await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }
  //#endregion

  //#region Create Guid UserId
  static Future<String> createGuidUserId() async {

    var uuid = Uuid();

    // // Generate a v1 (time-based) id
    // var v1 = uuid.v1(); // -> '6c84fb90-12c4-11e1-840d-7b25c5ee775a'
    //
    // var v1_exact = uuid.v1(options: {
    //   'node': [0x01, 0x23, 0x45, 0x67, 0x89, 0xab],
    //   'clockSeq': 0x1234,
    //   'mSecs': DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day).millisecondsSinceEpoch,
    //   'nSecs': 5678
    // }); // -> '710b962e-041c-11e1-9234-0123456789ab'

    // Generate a v4 (random) id
    var v4 = uuid.v4(); // -> '110ec58a-a0f2-4ac4-8393-c866d813b8d1'

    // // Generate a v4 (crypto-random) id
    // var v4_crypto = uuid.v4(options: {'rng': UuidUtil.cryptoRNG});
    // // -> '110ec58a-a0f2-4ac4-8393-c866d813b8d1'
    //
    // // Generate a v5 (namespace-name-sha1-based) id
    // var v5 = uuid.v5(Uuid.NAMESPACE_URL, 'www.google.com');
    // // -> 'c74a196f-f19d-5ea9-bffd-a2742432fc9c'

    return v4;
  }
  //#endregion

  //#region Make Phone Call
  static Future<void> makePhoneCall(String aPhoneNumber) async {
    try {
      final String _phoneCommand = "tel:$aPhoneNumber";
      if (await canLaunch(_phoneCommand)) {
        await launch(_phoneCommand);
      } else {
        throw 'Could not Make a Phone Call: $aPhoneNumber';
      }
    }
    catch (ex) {
      print ('${ex.toString()}');
    }
  }
  //#endregion

  //#region Send SMS
  static Future<void> sendSms(String aPhoneNumber) async {
    try {
      final String _phoneCommand = "sms:$aPhoneNumber";
      if (await canLaunch(_phoneCommand)) {
        await launch(_phoneCommand);
      } else {
        throw 'Could not Send an SMS to: $aPhoneNumber';
      }
    }
    catch (ex) {
      print ('${ex.toString()}');
    }
  }
  //#endregion

  //#region Send Email
  static Future<void> sendEmail(String aMailTo) async {
    try {
      String subjectText = 'Please enter a Subject and a Content ...';

      final Uri _emailLaunchUri = Uri(
          scheme: 'mailto',
          path: aMailTo,
          queryParameters: {
            'subject': '$subjectText'
          }
      );
      launch(_emailLaunchUri.toString());
    }
    catch (ex) {
      print ('Could not send an Email To: ${ex.toString()}');
    }
  }
  //#endregion

  //#region Launch In Browser
  static Future<void> launchInBrowser(String aUrl) async {
    try {
      if (await canLaunch(aUrl)) {
        await launch(
          aUrl,
          forceSafariVC: false,
          forceWebView: false,
//        headers: <String, String>{'my_header_key': 'my_header_value'},
        );
      } else {
        throw 'Could not Launch In Browser: $aUrl';
      }
    }
    catch (ex){
      print ('${ex.toString()}');
    }
  }
  //#endregion

  //#region Launch In Map By Address
  static Future<void> launchInMapByAddress(String aAddress) async {
    try {
      final url = 'https://www.google.com/maps/search/${Uri.encodeFull(aAddress)}';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
    catch (ex){
      print ('${ex.toString()}');
    }
  }
  //#endregion

  //#region Launch In Map By Coordinates
  static Future<void> launchInMapByCoordinates(String aAddress) async {
    try {
      var addresses = await Geocoder.local.findAddressesFromQuery(aAddress);

      if (addresses != null) {
        var position = addresses.first;

        double latitude = position.coordinates?.latitude;
        double longitude = position.coordinates?.longitude;

        String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
        if (await canLaunch(googleUrl)) {
          await launch(googleUrl);
        } else {
          print('<Utils> Launch In Map By Coordinates >>> Failed');
        }
      }
    }
    catch (e){
      await LoggerService.log('<Utils> Launch In Map By Coordinates >>> ERROR: ${e.toString()}');
      developer.log(
        'launchInMapByCoordinates',
        name: 'Utils',
        error: 'Launch In Map By Coordinates >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Open Calendar
  static Future<void> openCalendar(String aDateTime) async {
    try {
      // final String _dateTimeCommand = "content://com.android.calendar/time/$aDateTime";
      // final String _dateTimeCommand = "content://com.android.calendar/time/2015-05-28T09:00:00-07:00";
      final String _dateTimeCommand = "content://com.android.calendar/time/";
      if (await canLaunch(_dateTimeCommand)) {
        await launch(_dateTimeCommand);
      } else {
        throw 'Could not open Calendar: $aDateTime';
      }
    }
    catch (ex) {
      print ('${ex.toString()}');
    }
  }
  //#endregion

  //#region Add Event To Calendar
  static Future<void> addEventToCalendar(String aTitle, String aDescription, String aLocation, DateTime aStartDateTime, DateTime aEndDateTime) async {
    try {

      final Event event = Event(
        title: aTitle,
        description: aDescription,
        location: aLocation,
        startDate: aStartDateTime,
        endDate: aEndDateTime,
        //   endDate: DateTime.now().add(Duration(days: 1)),
      );

      Add2Calendar.addEvent2Cal(event);
    }
    catch (ex) {
      print ('${ex.toString()}');
    }
  }
  //#endregion

  //#region Convert Text Break Line From DB
  static String convertTextBreakLineFromDB(String aText) {
    String pageItemText = aText.replaceAll('\\n', '\n');
    return pageItemText;
  }
  //#endregion

  //#region Get Admin Permission
  static bool getAdminPermission(Constants.UserTypeEnum aUserTypeEnum)  {
    bool _hasPermission = false;

    switch (aUserTypeEnum) {
      case Constants.UserTypeEnum.SystemAdmin:
        _hasPermission = true;
        break;
      case  Constants.UserTypeEnum.RotaryMember:
        _hasPermission = false;
        break;
      case  Constants.UserTypeEnum.Guest:
        _hasPermission = false;
    }
    return _hasPermission;
  }
  //#endregion

  //#region Get Rotary Permission
  static bool getRotaryPermission(Constants.RotaryRolesEnum aRotaryRolesEnum)  {
    bool _hasPermission = false;
    switch (aRotaryRolesEnum) {
      case Constants.RotaryRolesEnum.RotaryManager:
      case Constants.RotaryRolesEnum.AreaManager:
      case Constants.RotaryRolesEnum.ClusterManager:
      case Constants.RotaryRolesEnum.ClubManager:
        _hasPermission = true;
        break;
      case Constants.RotaryRolesEnum.Gizbar:
      case Constants.RotaryRolesEnum.Member:
        _hasPermission = false;
        break;
    }
    return _hasPermission;
  }
//#endregion

  //#region Upload Image To Server
  static Future<String> uploadImageToServer(String aFileName) async {
    /// Upload File to HEROKU Server using MultipartFile
    try {
      String _getUrlUploadImage = GlobalsService.applicationServer + Constants.rotaryUtilUrl + "/uploadPersonCardImage";
      var request = http.MultipartRequest('POST', Uri.parse(_getUrlUploadImage));

      // Map<String, String> bodyFields = {'image': 'TEST.jpg'};
      // request.fields.addAll(bodyFields);
      // request.fields['image'] = 'TEST.jpg';
      request.files.add(await http.MultipartFile.fromPath('personCardImage', aFileName));
      http.StreamedResponse response = await request.send();

      if (response.statusCode <= 300) {
        print('Utils / Upload Image To Server / Return Value: ${response.reasonPhrase}');
        await LoggerService.log('<Utils> Upload Image To Server >>> ${response.reasonPhrase}');
        return response.reasonPhrase;
      } else {
        await LoggerService.log('<Utils> Upload Image To Server >>> Failed: ${response.statusCode}');
        print('<Utils> Upload Image To Server >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<Utils> Upload Image To Server >>> ERROR: ${e.toString()}');
      developer.log(
        'uploadImageToServer',
        name: 'Utils',
        error: 'Image >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Delete Image From Server
  static Future<String> deleteImageFromServer(String aFileName) async {
    /// Delete File from HEROKU Server
    try {
      String _deleteUrlImage = GlobalsService.applicationServer + Constants.rotaryUtilUrl + "/deletePersonCardImage/$aFileName";
      http.Response response = await http.delete(_deleteUrlImage);

      if (response.statusCode <= 300) {
        print('Utils / Upload Image To Server / Return Value: ${response.reasonPhrase}');
        await LoggerService.log('<Utils> Upload Image To Server >>> ${response.reasonPhrase}');
        return response.reasonPhrase;
      } else {
        await LoggerService.log('<Utils> Upload Image To Server >>> Failed: ${response.statusCode}');
        print('<Utils> Upload Image To Server >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<Utils> Upload Image To Server >>> ERROR: ${e.toString()}');
      developer.log(
        'uploadImageToServer',
        name: 'Utils',
        error: 'Image >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
//#endregion
}