import 'dart:developer' as developer;
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/services/logger_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalsService {
  static bool applicationType;          // SERVER Type  --->>> On(true): NETWORK    // Off (false): CLIENT
  static bool applicationRunningMode;   // Running Mode --->>> On(true): Production // Off (false): Debug Mode
  static String applicationServer;

  //#region Application Type
  //------------------------------------------------------------------------------
  static Future setApplicationType(bool aApplicationType) async {
    applicationType = aApplicationType;

    // SERVER Type: On(true) --->>> NET Mode    // Off (false): CLIENT Mode
    if (aApplicationType) applicationServer = Constants.SERVER_HOST_URL;
    else applicationServer = Constants.CLIENT_HOST_URL;
  }

  //#region Get Application Type
  // =============================================================================
  static Future getApplicationType() async {
    try {
      bool applicationType = await readApplicationTypeFromSP();
      if (applicationType == null) {
        applicationType = false;
      }
      return applicationType;
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

  //#region Read Application Type From Shared Preferences [ReadFromSP]
  // =============================================================================
  static Future readApplicationTypeFromSP() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool applicationType = prefs.getBool(Constants.rotaryApplicationType);

      if (applicationType == null) applicationType = true;  // SERVER Type [default]
      return applicationType;
    }
    catch (e){
      await LoggerService.log('<GlobalsService> Read Application Type From SP >>> ERROR: ${e.toString()}');
      developer.log(
        'readApplicationTypeFromSP',
        name: 'GlobalsService',
        error: 'Read Application Type From SP >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Write Application Type To Shared Preferences [WriteToSP]
  //=============================================================================
  static Future writeApplicationTypeToSP(bool aApplicationType) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(Constants.rotaryApplicationType, aApplicationType);
      return 'Status OK';
    }
    catch (e){
      await LoggerService.log('<GlobalsService> Write Application Type To SP >>> ERROR: ${e.toString()}');
      developer.log(
        'writeApplicationTypeToSP',
        name: 'GlobalsService',
        error: 'Write Application Type To SP >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion

  //#region Application Running Mode
  //------------------------------------------------------------------------------
  static Future setApplicationRunningMode(bool aApplicationRunningMode) async {
    applicationRunningMode = aApplicationRunningMode;
  }

  //#region Get Application RunningMode
  // =============================================================================
  static Future getApplicationRunningMode() async {
    try {
      bool applicationType = await readApplicationRunningModeFromSP();
      if (applicationType == null) {
        applicationType = false;
      }
      return applicationType;
    }
    catch (e) {
      await LoggerService.log('<GlobalsService> Get Application RunningMode >>> ERROR: ${e.toString()}');
      developer.log(
        'getApplicationRunningMode',
        name: 'GlobalsService',
        error: 'Get Application RunningMode >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Read Application RunningMode From Shared Preferences [ReadFromSP]
  // =============================================================================
  static Future readApplicationRunningModeFromSP() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool applicationRunningMode = prefs.getBool(Constants.rotaryApplicationRunningMode);

      if (applicationRunningMode == null) applicationRunningMode = true;  // Production Type [default]
      return applicationRunningMode;
    }
    catch (e){
      await LoggerService.log('<GlobalsService> Read Application RunningMode From SP >>> ERROR: ${e.toString()}');
      developer.log(
        'readApplicationRunningModeFromSP',
        name: 'GlobalsService',
        error: 'Read Application RunningMode From SP >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Write Application RunningMode To Shared Preferences [WriteToSP]
  //=============================================================================
  static Future writeApplicationRunningModeToSP(bool aApplicationRunningMode) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(Constants.rotaryApplicationRunningMode, aApplicationRunningMode);
      return 'Status OK';
    }
    catch (e){
      await LoggerService.log('<GlobalsService> Write Application RunningMode To SP >>> ERROR: ${e.toString()}');
      developer.log(
        'writeApplicationRunningModeToSP',
        name: 'GlobalsService',
        error: 'Write Application RunningMode To SP >>> ERROR: ${e.toString()}',
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
      await prefs.remove(Constants.rotaryApplicationType);
      await prefs.remove(Constants.rotaryApplicationRunningMode);
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
