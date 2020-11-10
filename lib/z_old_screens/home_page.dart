import 'package:flutter/material.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/events_list_bloc.dart';
import 'package:rotary_net/BLoCs/messages_list_bloc.dart';
import 'package:rotary_net/BLoCs/person_cards_list_bloc.dart';
import 'package:rotary_net/BLoCs/rotary_users_list_bloc.dart';
import 'package:rotary_net/services/route_generator_service.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      BlocProvider<MessagesListBloc>(
        bloc: MessagesListBloc(''),
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
}