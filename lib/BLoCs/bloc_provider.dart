import 'package:flutter/material.dart';
import 'package:rotary_net/BLoCs/bloc.dart';

// 1: BlocProvider is a generic class, which will manage the BloC lifecycle.
// The generic type T is scoped to be an object that implements the Bloc interface.
// This means that the provider can only store BLoC objects
class BlocProvider<T extends BloC> extends StatefulWidget {
  final T bloc;
  final Widget child;

  const BlocProvider({Key key, @required this.bloc, @required this.child}) : super(key: key);

  // 2: The of method allows widgets to retrieve the BlocProvider
  // from a descendant in the widget tree with the current build context
  static T of<T extends BloC>(BuildContext context) {
    // final type = _providerType<BlocProvider<T>>();
    final BlocProvider<T> provider = context.findAncestorWidgetOfExactType<BlocProvider<T>>();
    return provider.bloc;
  }

  // 3: This is some trampolining to get a reference to the generic type.
  // static Type _providerType<T>() => T;

  @override
  State createState() => _BlocProviderState();
}

class _BlocProviderState extends State<BlocProvider> {
  // 4: The widget’s build method is a pass through to the widget’s child.
  // This widget will not render anything
  @override
  Widget build(BuildContext context) => widget.child;

  // 5: Finally, the only reason why the provider inherits from StatefulWidget is
  // to get access to the dispose method.
  // When this widget is removed from the tree,
  // Flutter will call the dispose method, which will in turn, close the stream
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}
