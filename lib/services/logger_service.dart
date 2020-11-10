import 'dart:io';
import 'dart:core';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';

class LoggerService {

  static final lock = Lock();  /// uses the “synchronized” package
  static File logFile;

  static Future initializeLogging() async {

    final directory = await getApplicationDocumentsDirectory();
    var docsDir = directory.path;
    var _logFilename = Constants.rotaryLoggerFileName;
    String loggerFileName = '$docsDir/$_logFilename';

    logFile = createLogFile(loggerFileName);

    final text = '${new DateTime.now()}: LOGGING STARTED\n';

    /// Open the file, write the string in the given encoding, and close the file
    return logFile.writeAsString(text, mode: FileMode.write, flush: true);
  }

  static Future log(String aLogText) async {
    final text = '${new DateTime.now()}: $aLogText\n';

    return lock.synchronized(() async {
      await logFile.writeAsString(text, mode: FileMode.append, flush: true);
    });
  }

  static File createLogFile(aLogFileName) => File(aLogFileName);
//  static File createLogFile(aLogFileName) {
//    return File(aLogFileName);
//  }
}