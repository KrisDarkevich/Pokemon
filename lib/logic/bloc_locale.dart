import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuccessLocaleState {
  final String locale;

  SuccessLocaleState(this.locale);
}

class ChangeLocaleEvent {
  final String locale;

  ChangeLocaleEvent(this.locale);
}

class LocaleBloc extends Bloc<ChangeLocaleEvent, SuccessLocaleState> {
  LocaleBloc() : super(SuccessLocaleState('en')) {
    on<ChangeLocaleEvent>(
      (event, emit) {
        emit(SuccessLocaleState(event.locale));
      },
    );
  }
}
