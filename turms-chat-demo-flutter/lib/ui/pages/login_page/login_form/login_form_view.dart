import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../components/t_checkbox/t_checkbox.dart';
import '../../../l10n/app_localizations.dart';
import '../../../themes/theme_config.dart';
import 'login_form_controller.dart';

class LoginFormView extends StatelessWidget {
  const LoginFormView(this.loginFormController, {super.key});

  final LoginFormController loginFormController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = loginFormController.appLocalizations;
    loginFormController.rememberMe ??=
        loginFormController.appSettings.getRememberMe() ?? false;
    final isWaitingLoginRequest = loginFormController.isWaitingLoginRequest;
    final userLoginInfo = loginFormController.userLoginInfos.firstOrNull;
    return FocusScope(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          loginFormController.submit();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Form(
          key: loginFormController.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                autofocus: true,
                initialValue: userLoginInfo?.userId.toString(),
                cursorColor: ThemeConfig.primary,
                // Length for the max digit of 8-bytes number
                maxLength: 20,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    // fix height regardless of whether or not an error is displayed.
                    helperText: ' ',
                    // hide length counter
                    counterText: '',
                    prefixIcon: const Icon(Symbols.person_outline_rounded,
                        color: ThemeConfig.textColorSecondary),
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: ThemeConfig.borderColor)),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: ThemeConfig.primary,
                    )),
                    errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: ThemeConfig.error)),
                    focusedErrorBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: ThemeConfig.focusedError)),
                    hintText: localizations.userId),
                onFieldSubmitted: (value) => loginFormController.submit(),
                onSaved: loginFormController.setUserId,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.pleaseEnterUserId;
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: userLoginInfo?.password,
                cursorColor: ThemeConfig.primary,
                obscureText: true,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    // fix height regardless of whether or not an error is displayed.
                    helperText: ' ',
                    // contentPadding: EdgeInsets.only(bottom: 8),
                    prefixIcon: const Icon(Symbols.lock_outline_rounded,
                        color: ThemeConfig.textColorSecondary),
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: ThemeConfig.borderColor)),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: ThemeConfig.primary,
                    )),
                    errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: ThemeConfig.error)),
                    focusedErrorBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: ThemeConfig.focusedError)),
                    hintText: localizations.userPassword),
                onFieldSubmitted: (value) => loginFormController.submit(),
                onSaved: loginFormController.setPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.pleaseEnterPassword;
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              TCheckbox(
                loginFormController.rememberMe!,
                localizations.rememberMe,
                onCheckedChanged: (bool checked) {
                  loginFormController.rememberMe = checked;
                },
              ),
              const SizedBox(
                height: 32,
              ),
              _buildLoginButton(isWaitingLoginRequest, localizations, theme)
            ],
          )),
    );
  }

  Widget _buildLoginButton(bool isWaitingLoginRequest,
          AppLocalizations localizations, ThemeData theme) =>
      FilledButton(
        onPressed: isWaitingLoginRequest ? null : loginFormController.submit,
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 56),
          shape: const RoundedRectangleBorder(
            borderRadius: ThemeConfig.borderRadius4,
          ),
          disabledBackgroundColor: ThemeConfig.primaryDisabled,
        ),
        child: isWaitingLoginRequest
            ? const SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Text(
                localizations.login,
                style: theme.textTheme.labelMedium!
                    .copyWith(fontSize: 20, color: Colors.white),
              ),
      );
}
