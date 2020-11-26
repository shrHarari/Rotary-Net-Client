import 'package:flutter/material.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/events_list_bloc.dart';
import 'package:rotary_net/BLoCs/messages_list_bloc.dart';
import 'package:rotary_net/BLoCs/person_cards_list_bloc.dart';
import 'package:rotary_net/BLoCs/rotary_users_list_bloc.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/services/connected_user_service.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/services/route_generator_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/utils/utils_class.dart';

void main() => runApp(RotaryNetApp());

class RotaryNetApp extends StatelessWidget {

  final ConnectedUserService connectedUserService = ConnectedUserService();
  final userGlobal = ConnectedUserGlobal();

  //#region Get All Required Data For Build
  Future<DataRequiredForBuild> getAllRequiredDataForBuild() async {

    /// Call Global first ===>>> Initiate Logger
    await initializeGlobalValues();
    await Utils.checkConnection();

    ConnectedUserObject _connectedUserObj = await initializeConnectedUserObject();
    Constants.RotaryRolesEnum _rotaryRolesEnum = await initializeRotaryRolesEnum();

    return DataRequiredForBuild(
      connectedUserObj: _connectedUserObj,
      rotaryRolesEnum: _rotaryRolesEnum,
    );
  }
  //#endregion

  //#region Initialize Global Values [LOGGER, ApplicationType, ApplicationRunningMode]
  Future initializeGlobalValues() async {
    await LoggerService.initializeLogging();
    await LoggerService.log('<${this.runtimeType}> Logger was initiated');

    bool _applicationType = await GlobalsService.readApplicationTypeFromSP();
    await GlobalsService.setApplicationType(_applicationType);

    bool _applicationRunningMode = await GlobalsService.readApplicationRunningModeFromSP();
    await GlobalsService.setApplicationRunningMode(_applicationRunningMode);
  }
  //#endregion

  //#region Initialize Connected UserObject [CONNECTED USER]
  Future <ConnectedUserObject> initializeConnectedUserObject() async {
    ConnectedUserObject _currentConnectedUserObj = await connectedUserService.readConnectedUserObjectDataFromSecureStorage();

    userGlobal.setConnectedUserObject(_currentConnectedUserObj);

    return _currentConnectedUserObj;
  }
  //#endregion

  //#region Initialize RotaryRolesEnum [CONNECTED USER]
  Future <Constants.RotaryRolesEnum> initializeRotaryRolesEnum() async {
    Constants.RotaryRolesEnum _currentRotaryRolesEnum  = await connectedUserService.readRotaryRoleEnumDataFromSecureStorage();

    userGlobal.setRotaryRoleEnum(_currentRotaryRolesEnum);

    return _currentRotaryRolesEnum;
  }
  //#endregion

  @override
  Widget build(BuildContext context) {

      startRouteGenerator(DataRequiredForBuild dataRequiredForBuild) {
        return
          BlocProvider<MessagesListBloc>(
            bloc: MessagesListBloc(dataRequiredForBuild.connectedUserObj.personCardId),
            child: BlocProvider<RotaryUsersListBloc>(
              bloc: RotaryUsersListBloc(),
              child: BlocProvider<EventsListBloc>(
                bloc: EventsListBloc(),
                child: BlocProvider<PersonCardsListBloc>(
                  bloc: PersonCardsListBloc(),
                  child: MaterialApp(
                    title: 'RotaryNet',
                    initialRoute: '/',
                    onGenerateRoute: RouteGenerator.generateRoute,
                  ),
                ),
              ),
            ),
          );
      }

      return FutureBuilder(
          future: getAllRequiredDataForBuild(),
          builder: ((context, snapshot){
            if (snapshot.hasData) {
              return startRouteGenerator(snapshot.data);
            } else {
              // return CircularProgressIndicator(strokeWidth: 10,);
              // return Loading();
              return Container(
                  color: Colors.lightBlue[50],
                );
            }
          })
      );
  }

  // @override
  // Widget build(BuildContext context) {
  //
  //   final ConnectedUserService connectedUserService = ConnectedUserService();
  //   ConnectedUserObject _connectedUserObj = await connectedUserService.readConnectedUserObjectDataFromSecureStorage();
  //   return
  //     BlocProvider<MessagesListBloc>(
  //       bloc: MessagesListBloc(),
  //       child: BlocProvider<RotaryUsersListBloc>(
  //         bloc: RotaryUsersListBloc(),
  //         child: BlocProvider<EventsListBloc>(
  //           bloc: EventsListBloc(),
  //           child: BlocProvider<PersonCardsListBloc>(
  //             bloc: PersonCardsListBloc(),
  //             child: MaterialApp(
  //               title: 'RotaryNet',
  //               initialRoute: '/',
  //               onGenerateRoute: RouteGenerator.generateRoute,
  //       ),
  //           ),
  //         ),
  //   ),
  //     );
  // }
}

class DataRequiredForBuild {
  ConnectedUserObject connectedUserObj;
  Constants.RotaryRolesEnum rotaryRolesEnum;
  bool applicationMode;

  DataRequiredForBuild({
    this.connectedUserObj,
    this.rotaryRolesEnum,
  });
}