import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:rotary_net/services/event_service.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

class AwsService {

  //#region Upload AWS Image To Server
  static Future<Map<String, dynamic>> awsUploadImageToServer(
      String aObjectId,                   /// aObjectId: Id of an Object [PersonCard || Image]
      PickedFile aPickedFile,             /// aPickedFile: File to be Uploaded
      String aFileName,                   /// aFileName: Name of the file to be uploaded
      String aFileType,                   /// aFileType: [".jpg" || ".png" || ".jpeg"]
      String aOldFileName,                /// aOldFileName: Name of the Old file to be deleted
      {String aBucketFolderName = ''}     /// aBucketFolderName (optional): Name of Bucket Folder On AWS-S3
      ) async {

    try {
      AwsGenerateImageUrl generateAwsImageUrl = AwsGenerateImageUrl();
      await generateAwsImageUrl.generateUrl(aFileName, aFileType, aBucketFolderName);

      String uploadUrl;
      if (generateAwsImageUrl.isGenerated != null && generateAwsImageUrl.isGenerated) {
        uploadUrl = generateAwsImageUrl.uploadBucketUrl;
      } else {
          return {
            "returnCode" : 301,
            "message" : generateAwsImageUrl.message,
            "imageUrl" : null
          };
      }

      AwsUploadFile uploadAwsFile = AwsUploadFile();
      await uploadAwsFile.upload(uploadUrl, aPickedFile);

      if (uploadAwsFile.isUploaded != null && uploadAwsFile.isUploaded) {
        bool isSaved = await onSaveImage(aObjectId, aBucketFolderName, generateAwsImageUrl.downloadImageUrl);
        if (isSaved) {
          onImageSuccessfullySaved(aOldFileName, aBucketFolderName);
          return {
            "returnCode" : 200,
            "message" : "Image Successfully Saved",
            "imageUrl" : generateAwsImageUrl.downloadImageUrl
          };
        } else {
          return {
            "returnCode" : 302,
            "message" : "Failed to save image",
            "imageUrl" : null
          };
        }
      } else {
        return {
          "returnCode" : 303,
          "message" : uploadAwsFile.message,
          "imageUrl" : null
        };
      }
    }
    catch (e) {
      await LoggerService.log('<AwsService> Upload AWS Image To Server >>> ERROR: ${e.toString()}');
      developer.log(
        'uploadAwsImageToServer',
        name: 'AwsService',
        error: 'Image >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region On Save Image
  static Future <bool> onSaveImage(String aObjectId, String aBucketFolderName, String aImageUrl) async {
    /// Callback called when image is successfully uploaded to upload url
    /// and now you can save the url somewhere like a database.
    /// If saving to database is successful return true, else false

    switch (aBucketFolderName) {
      case "EventImages":
        EventService eventService = EventService();
        eventService.updateEventImageUrlById(aObjectId, aImageUrl);
        break;
      case "PersonCardImages":
        PersonCardService personCardService = PersonCardService();
        personCardService.updatePersonCardImageUrlById(aObjectId, aImageUrl);
        break;
      default:
    }
    // print('AwsService / onSaveImage / aImageUrl: $aImageUrl');
    return true;
  }
  //#endregion

  //#region On Image Successfully Saved
  static Future <bool> onImageSuccessfullySaved(String aFileNameToDelete, String aBucketFolderName) async {
    /// Callback called when image is successfully saved to database
    /// and you return true in onSaveImage
    AwsDeleteFile deleteAwsFile = AwsDeleteFile();
    await deleteAwsFile.delete(aFileNameToDelete, aBucketFolderName);
    if (deleteAwsFile.isDeleted != null && deleteAwsFile.isDeleted) {
      return true;
    } else {
      return false;
    }
    // return true;
  }
  //#endregion
}

//#region CLASS Generate AWS Image Url
class AwsGenerateImageUrl {
  bool success;
  String message;

  bool isGenerated;
  String uploadBucketUrl;           // AWS S3 Destination Url --->>> Where the Image wil be uploaded
  String downloadImageUrl;          // Image Url reference

  Future<void> generateUrl(String aFileName, String aFileType, String aBucketFolderName) async {
    try {
      Map bodyParams = {
        "fileName": aFileName,
        "fileType": aFileType,
        "bucketFolderName": aBucketFolderName
      };

      String _generateImageUrl = GlobalsService.applicationServer + Constants.rotaryAwsUrl + '/generatePreSignedUrl';
      var response = await http.post(_generateImageUrl, body: bodyParams);

      var result = jsonDecode(response.body);

      if (result['success'] != null) {
        success = result['success'];
        message = result['message'];

        if ((response.statusCode == 201) && (success)) {
          print('Upload Bucket Url: ${result["uploadBucketUrl"]}');
          print('Download Image Url: ${result["downloadImageUrl"]}');
          isGenerated = true;
          uploadBucketUrl = result["uploadBucketUrl"];
          downloadImageUrl = result["downloadImageUrl"];
        }
      }
    }
    catch (e) {
      await LoggerService.log('<AwsService> AWS Generate Url >>> ERROR: ${e.toString()}');
      developer.log(
        'AwsService',
        name: 'GenerateImageUrl',
        error: 'AWS Generate Url >>> ERROR: ${e.toString()}',
      );
      message = 'GenerateAwsImageUrl / AWS Generate Url >>> ERROR: ${e.toString()}';
      return null;
    }
  }
}
//#endregion

//#region CLASS Upload AWS File
class AwsUploadFile {
  // bool success;
  String message;

  bool isUploaded;

  Future<void> upload(String aAwsBucketUrl, PickedFile aPickedFileImage) async {
    try {
      Uint8List bytes = await aPickedFileImage.readAsBytes();
      var response = await http.put(aAwsBucketUrl, body: bytes);
      if (response.statusCode == 200) {
        isUploaded = true;
        message = 'AWS Upload File >>> Success';
      }
    } catch (e) {
      message = 'AWS Upload File >>> ERROR: ${e.toString()}';
      return null;
    }
  }
}
//#endregion

//#region CLASS Delete AWS File
class AwsDeleteFile {
  bool success;
  String message;

  bool isDeleted;
  String deletedData;

  Future<void> delete(String aFileName, String aBucketFolderName) async {
    try {
      /// Check: Is there any File to delete ?
      if ((aFileName == null) || (aFileName == ''))
      {
        isDeleted = true;
        return;
      }

      Map bodyParams = {
        "fileName": aFileName,
        "bucketFolderName": aBucketFolderName
      };

      String _deleteUrl = GlobalsService.applicationServer + Constants.rotaryAwsUrl + '/deleteFile';
      var response = await http.post(_deleteUrl, body: bodyParams);

      var result = jsonDecode(response.body);

      if (result['success'] != null) {
        success = result['success'];
        message = result['message'];

        if ((response.statusCode == 202) && (success)) {
          isDeleted = true;
          // deletedData = result["deletedData"];
        }
      }
    }
    catch (e) {
      await LoggerService.log('<AwsService> AWS Delete File >>> ERROR: ${e.toString()}');
      developer.log(
        'AwsService',
        name: 'AwsDeleteFile',
        error: 'AWS Delete File >>> ERROR: ${e.toString()}',
      );
      message = 'AWS Delete File >>> ERROR: ${e.toString()}';
      return null;
    }
  }
}
//#endregion