import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:musicapp1/dicontainer.config.dart';

final getIT = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => await getIT.init();
