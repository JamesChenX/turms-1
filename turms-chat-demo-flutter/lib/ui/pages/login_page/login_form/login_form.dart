import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'login_form_controller.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => LoginFormController();
}