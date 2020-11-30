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
      AwsGenerateImageUrlService generateAwsImageUrlService = AwsGenerateImageUrlService();
      await generateAwsImageUrlService.generateUrl(aFileName, aFileType, aBucketFolderName);

      String uploadUrl;
      if (generateAwsImageUrlService.isGenerated != null && generateAwsImageUrlService.isGenerated) {
        uploadUrl = generateAwsImageUrlService.uploadBucketUrl;
      } else {
        return {
          "returnCode" : 301,
          "message" : generateAwsImageUrlService.message,
          "imageUrl" : null
        };
      }

      AwsUploadFileService uploadAwsFileService = AwsUploadFileService();
      await uploadAwsFileService.upload(uploadUrl, aPickedFile);

      if (uploadAwsFileService.isUploaded != null && uploadAwsFileService.isUploaded) {
        bool isSaved = await onSaveImage(aObjectId, aBucketFolderName, generateAwsImageUrlService.downloadImageUrl);
        if (isSaved) {
          onImageSuccessfullySaved(aOldFileName, aBucketFolderName);
          return {
            "returnCode" : 200,
            "message" : "Image Successfully Saved",
            "imageUrl" : generateAwsImageUrlService.downloadImageUrl
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
          "message" : uploadAwsFileService.message,
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
    /// Callback called when image is successfully uploaded to AWS upload url
    /// and now has to save the url to the database.
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
    return true;
  }
  //#endregion

  //#region On Image Successfully Saved
  static Future <bool> onImageSuccessfullySaved(String aFileNameToDelete, String aBucketFolderName) async {
    /// Callback called when image is successfully saved to database
    /// and you return true in onSaveImage
    /// --->>> Delete the old Image from AWS
    AwsDeleteFileService deleteAwsFileService = AwsDeleteFileService();
    await deleteAwsFileService.delete(aFileNameToDelete, aBucketFolderName: aBucketFolderName);
    if (deleteAwsFileService.isDeleted != null && deleteAwsFileService.isDeleted) {
      return true;
    } else {
      return false;
    }
    // return true;
  }
  //#endregion
}

//#region CLASS Generate AWS Image Url
class AwsGenerateImageUrlService {
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
        } else {
          await LoggerService.log('<AwsService> Aws Generate Image Url >>> Failed: $message');
          print('<AwsService> Aws Generate Image Url >>> Failed');
        }
      }
    }
    catch (e) {
      await LoggerService.log('<AwsService> Aws Generate Image Url Service >>> ERROR: ${e.toString()}');
      developer.log(
        'AwsService',
        name: 'AwsGenerateImageUrlService',
        error: 'Aws Generate Image Url Service >>> ERROR: ${e.toString()}',
      );
      message = 'Aws Generate Image Url Service >>> ERROR: ${e.toString()}';
      return null;
    }
  }
}
//#endregion

//#region CLASS Upload AWS File Service
class AwsUploadFileService {
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
      } else {
        message = "Failed to upload image";
        await LoggerService.log('<AwsService> Aws Upload File Service >>> Failed');
        print('<AwsService> Aws Upload File Service >>> Failed');
      }
    } catch (e) {
      await LoggerService.log('<AwsService> Aws Upload File Service >>> ERROR: ${e.toString()}');
      developer.log(
        'AwsService',
        name: 'AwsUploadFileService',
        error: 'Aws Upload File Service >>> ERROR: ${e.toString()}',
      );
      message = 'Aws Upload File Service >>> ERROR: ${e.toString()}';
      return null;
    }
  }
}
//#endregion

//#region CLASS Delete AWS File Service
class AwsDeleteFileService {
  bool success;
  String message;

  bool isDeleted;
  String deletedData;

  Future<void> delete(String aFileName, {String aBucketFolderName = ''}) async {
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
        } else {
          await LoggerService.log('<AwsService> Aws Delete File Service >>> Failed');
          print('<AwsService> Aws Delete File Service >>> Failed');
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