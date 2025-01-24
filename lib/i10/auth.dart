import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';

class LabelOverrides extends PtLocalizations {
  const LabelOverrides();

  @override
  String get emailInputLabel => 'Digite seu e-mail';

  @override
  String get passwordInputLabel => 'Digite sua senha';

  @override
  String get emailIsNotVerifiedText => 'E-mail não verificado';

  @override
  String get dismissButtonLabel => 'Ignorar';

  @override
  String get sendVerificationEmailLabel => 'Enviar e-mail de verificação';
}
