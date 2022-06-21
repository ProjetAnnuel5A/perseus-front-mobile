part of 'language_cubit.dart';

abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object> get props => [];
}

class LanguageInitial extends LanguageState {
  const LanguageInitial(this.langCode);

  final String langCode;

  @override
  List<Object> get props => [langCode];
}
