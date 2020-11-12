import 'dart:developer' as developer;
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/services/logger_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalsService {
  static bool applicationMode;    // SERVER Mode --->>> true // CLIENT Mode --->>> False
  static String applicationServer;

  //#region Application Mode
  //------------------------------------------------------------------------------
  static Future setApplicationMode(bool aApplicationMode) async {
    applicationMode = aApplicationMode;

    // SERVER Mode --->>> true // CLIENT Mode --->>> False
    if (aApplicationMode) applicationServer = Constants.SERVER_HOST_URL;
    else applicationServer = Constants.CLIENT_HOST_URL;
  }

  //#region Get Application Mode
  // =============================================================================
  static Future getApplicationMode() async {
    try {
      bool applicationMode = await readApplicationModeFromSP();
      if (applicationMode == null) {
        applicationMode = false;
      }
      return applicationMode;
      }
      catch (e) {
        await LoggerService.log('<GlobalsService> Get Application Mode >>> ERROR: ${e.toString()}');
        developer.log(
          'getApplicationMode',
          name: 'GlobalsService',
          error: 'Get Application Mode >>> ERROR: ${e.toString()}',
        );
        return null;
    }
  }
  //#endregion

  //#region Read Application Mode From Shared Preferences [ReadFromSP]
  // =============================================================================
  static Future readApplicationModeFromSP() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool applicationMode = prefs.getBool(Constants.rotaryApplicationMode);

      if (applicationMode == null) applicationMode = true;  // SERVER Mode [default]
      return applicationMode;
    }
    catch (e){
      await LoggerService.log('<GlobalsService> Read Application Mode From SP >>> ERROR: ${e.toString()}');
      developer.log(
        'readApplicationModeFromSP',
        name: 'GlobalsService',
        error: 'Read Application Mode From SP >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Write Application Mode To Shared Preferences [WriteToSP]
  //=============================================================================
  static Future writeApplicationModeToSP(bool aApplicationMode) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(Constants.rotaryApplicationMode, aApplicationMode);
      return 'Status OK';
    }
    catch (e){
      await LoggerService.log('<GlobalsService> Write Application Mode To SP >>> ERROR: ${e.toString()}');
      developer.log(
        'writeApplicationModeToSP',
        name: 'GlobalsService',
        error: 'Write Application Mode To SP >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion

  //#region Clear Globals Data From Shared Preferences
  //=============================================================================
  static Future clearGlobalsDataFromSharedPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Constants.rotaryApplicationMode);
    }
    catch (e){
      await LoggerService.log('<GlobalsService> Clear Globals Data From SharedPreferences >>> ERROR: ${e.toString()}');
      developer.log(
        'clearGlobalsDataFromSharedPreferences',
        name: 'GlobalsService',
        error: 'Clear Globals Data From SharedPreferences >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
//#endregion
}
