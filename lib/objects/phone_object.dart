import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'dart:developer' as developer;
import 'package:rotary_net/services/logger_service.dart';

class PhoneObject {
  String phoneNumber;
  String phoneNumberDialCode;
  String phoneNumberParse;
  String phoneNumberCleanLongFormat;

  PhoneObject({
    this.phoneNumber,
    this.phoneNumberDialCode,
    this.phoneNumberParse,
    this.phoneNumberCleanLongFormat});

  void setPhoneObject(
      String aPhoneNumber,
      String aPhoneDialCode,
      String aPhoneParse,
      String aPhoneNumberCleanLongFormat) {

        phoneNumber = aPhoneNumber;
        phoneNumberDialCode = aPhoneDialCode;
        phoneNumberParse = aPhoneParse;
        phoneNumberCleanLongFormat = aPhoneNumberCleanLongFormat;
  }

  // Get Phone Number Parse
  //=====================================
  Future <void> setPhoneNumberParse(String phoneNumber) async {
    try {
      PhoneNumber _number;
      String _phoneNumberDialCode;
      String _phoneNumberParse;
      String _phoneNumberCleanLongFormat;

      if (phoneNumber.isEmpty) {
        _phoneNumberDialCode = '';
        _phoneNumberParse = '';
        _phoneNumberCleanLongFormat = '';
      }
      else {
        _number = await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber);
        _phoneNumberDialCode = _number.dialCode;
        _phoneNumberParse = _number.parseNumber();
        _phoneNumberCleanLongFormat = _phoneNumberDialCode + _phoneNumberParse;
      }

      setPhoneObject(phoneNumber, _phoneNumberDialCode, _phoneNumberParse, _phoneNumberCleanLongFormat);
    }
    catch (e){
      await LoggerService.log('<PhoneObject> Set Phone Number Parse >>> ERROR: ${e.toString()}');
      developer.log(
        'setPhoneNumberParse',
        name: 'PhoneObject',
        error: 'Failed: Set Phone Number Parse >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
}