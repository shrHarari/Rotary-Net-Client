import 'dart:developer' as developer;
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/services/logger_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalsService {
  static bool isDebugMode;

  //#region Debug Mode
  //------------------------------------------------------------------------------
  static Future setDebugMode(bool aDebugMode) async {
    isDebugMode = aDebugMode;
  }

  //#region Get Debug Mode
  // =============================================================================
  static Future getDebugMode() async {
    try {
      bool debugMode = await readDebugModeFromSP();
      if (debugMode == null) {
        debugMode = false;
      }
      return debugMode;
      }
      catch (e) {
        await LoggerService.log('<GlobalsService> Get Debug Mode >>> ERROR: ${e.toString()}');
        developer.log(
          'getDebugMode',
          name: 'GlobalsService',
          error: 'Get Debug Mode >>> ERROR: ${e.toString()}',
        );
        return null;
    }
  }
  //#endregion

  //#region Read Debug Mode From Shared Preferences [ReadFromSP]
  // =============================================================================
  static Future readDebugModeFromSP() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool debugMode = prefs.getBool(Constants.rotaryDebugMode);
      return debugMode;
    }
    catch (e){
      await LoggerService.log('<GlobalsService> Read Debug Mode From SP >>> ERROR: ${e.toString()}');
      developer.log(
        'readDebugModeFromSP',
        name: 'GlobalsService',
        error: 'Read Debug Mode From SP >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Write Debug Mode To Shared Preferences [WriteToSP]
  //=============================================================================
  static Future writeDebugModeToSP(bool aDebugMode) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(Constants.rotaryDebugMode, aDebugMode);
      return 'Status OK';
    }
    catch (e){
      await LoggerService.log('<GlobalsService> Write Debug Mode To SP >>> ERROR: ${e.toString()}');
      developer.log(
        'writeDebugModeToSP',
        name: 'GlobalsService',
        error: 'Write Debug Mode To SP >>> ERROR: ${e.toString()}',
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
      await prefs.remove(Constants.rotaryDebugMode);
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
