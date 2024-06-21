import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

typedef AppLifecycleStateNotifier = ValueNotifier<AppLifecycleState>;

class AppLifecycleObserver extends StatefulWidget {
  final Widget child;

  const AppLifecycleObserver({required this.child, super.key});

  @override
  _AppLifecycleObserverState createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends State<AppLifecycleObserver> {
  late final AppLifecycleStateNotifier lifecycleNotifier;

  @override
  void initState() {
    super.initState();
    lifecycleNotifier = ValueNotifier(AppLifecycleState.inactive);
    WidgetsBinding.instance.addObserver(LifecycleEventHandler(lifecycleNotifier));
  }

  @override
  Widget build(BuildContext context) {
    return InheritedProvider<AppLifecycleStateNotifier>.value(
      value: lifecycleNotifier,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(LifecycleEventHandler(lifecycleNotifier));
    super.dispose();
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AppLifecycleStateNotifier notifier;

  LifecycleEventHandler(this.notifier);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    notifier.value = state;
  }
}
