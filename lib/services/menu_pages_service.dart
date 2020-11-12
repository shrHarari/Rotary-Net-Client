import 'dart:async';
import 'dart:convert';
import 'dart:collection';
import 'package:http/http.dart';
import 'package:rotary_net/objects/menu_page_object.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

class MenuPagesService {

  //#region * Get MenuPage Content By PageName [GET]
  // =========================================================
  Future<Map<String, dynamic>> getMenuPageContentByPageName(String aPageName) async {

    Map<String, dynamic> pageContentItemsMap = HashMap();

    try {
      String _getUrlMenuPage = GlobalsService.applicationServer + Constants.rotaryMenuPagesContentUrl + "/$aPageName";
      Response response = await get(_getUrlMenuPage);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;

        dynamic pageContentItems = jsonDecode(jsonResponse);
        List<dynamic> pageContentItemsList;
        if (pageContentItems['pageItems'] != null) {
          pageContentItemsList = pageContentItems['pageItems'] as List;
        } else {
          pageContentItemsList = [];
        }

        List<PageContentItemObject> pageContentItemsObjList = pageContentItemsList.map((pageItem) =>
                  PageContentItemObject.fromJson(pageItem)).toList();

        pageContentItemsMap = Map.fromIterable(pageContentItemsObjList,
            key: (pageItem) => pageItem.itemName,
            value: (pageItem) => pageItem.itemContent);

        return pageContentItemsMap;
      } else {
        await LoggerService.log('<MenuPagesService> Get MenuPage Content By PageName >>> Failed: ${response.statusCode}');
        print('<MenuPagesService> Get MenuPage Content By PageName >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<MenuPagesService> Get MenuPage Content By PageName >>> ERROR: ${e.toString()}');
      developer.log(
        'getMenuPageContentByPageName',
        name: 'MenuPagesService',
        error: 'Get MenuPage Content By PageName >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

}
