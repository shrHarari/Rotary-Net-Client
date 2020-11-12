import 'package:flutter/material.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/events_list_bloc.dart';
import 'package:rotary_net/BLoCs/messages_list_bloc.dart';
import 'package:rotary_net/BLoCs/person_cards_list_bloc.dart';
import 'package:rotary_net/BLoCs/rotary_users_list_bloc.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/services/connected_user_service.dart';
import 'package:rotary_net/services/connection_service.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/services/route_generator_service.dart';

void main() => runApp(RotaryNetApp());

class RotaryNetApp extends StatelessWidget {

  final ConnectedUserService connectedUserService = ConnectedUserService();

  //#region Get All Required Data For Build
  Future<DataRequiredForBuild> getAllRequiredDataForBuild() async {

    /// Call Global first ===>>> Initiate Logger
    bool _applicationMode = await initializeGlobalValues();
    await ConnectionService.checkConnection();

    ConnectedUserObject _connectedUserObj = await initializeConnectedUserObject();

    return DataRequiredForBuild(
      applicationMode: _applicationMode,
      connectedUserObj: _connectedUserObj,
    );
  }
  //#endregion

  //#region Initialize Global Values [LOGGER, DEBUG Mode]
  Future <bool> initializeGlobalValues() async {
    await LoggerService.initializeLogging();
    await LoggerService.log('<${this.runtimeType}> Logger was initiated');

    bool _applicationMode = await GlobalsService.getApplicationMode();
    await GlobalsService.setApplicationMode(_applicationMode);

    return _applicationMode;
  }
  //#endregion

  //#region Initialize Connected UserObject [CONNECTED USER]
  Future <ConnectedUserObject> initializeConnectedUserObject() async {
    ConnectedUserObject _currentConnectedUserObj = await connectedUserService.readConnectedUserObjectDataFromSecureStorage();

    var userGlobal = ConnectedUserGlobal();
    userGlobal.setConnectedUserObject(_currentConnectedUserObj);

    return _currentConnectedUserObj;
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
  bool applicationMode;

  DataRequiredForBuild({
    this.connectedUserObj,
    this.applicationMode,
  });
}