import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../themes/index.dart';

import '../../../components/t_checkbox/t_checkbox.dart';
import 'login_form_controller.dart';

class LoginFormView extends StatelessWidget {
  const LoginFormView(this.loginFormController, {super.key});

  final LoginFormController loginFormController;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final localizations = loginFormController.appLocalizations;
    loginFormController.rememberMe ??=
        loginFormController.appSettings.getRememberMe() ?? false;
    final isWaitingLoginRequest = loginFormController.isWaitingLoginRequest;
    final userLoginInfo = loginFormController.userLoginInfos.firstOrNull;
    final borderError = UnderlineInputBorder(
        borderSide: BorderSide(color: theme.colorScheme.error));
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
                cursorColor: theme.primaryColor,
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
                    prefixIcon: Icon(Symbols.person_outline_rounded,
                        color: theme.inputDecorationTheme.iconColor),
                    // color: ThemeConfig.textColorSecondary),
                    isCollapsed: true,
                    contentPadding: Sizes.paddingV16,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: theme.dividerColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: theme.primaryColor,
                    )),
                    errorBorder: borderError,
                    focusedErrorBorder: borderError,
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
                cursorColor: theme.primaryColor,
                obscureText: true,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    // fix height regardless of whether or not an error is displayed.
                    helperText: ' ',
                    // contentPadding: EdgeInsets.only(bottom: 8),
                    prefixIcon: Icon(Symbols.lock_outline_rounded,
                        color: theme.inputDecorationTheme.iconColor),
                    isCollapsed: true,
                    contentPadding: Sizes.paddingV16,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: theme.dividerColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: theme.primaryColor,
                    )),
                    errorBorder: borderError,
                    focusedErrorBorder: borderError,
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
              Sizes.sizedBoxH12,
              TCheckbox(
                loginFormController.rememberMe!,
                localizations.rememberMe,
                onCheckedChanged: (bool checked) {
                  loginFormController.rememberMe = checked;
                },
              ),
              Sizes.sizedBoxH32,
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
            borderRadius: Sizes.borderRadiusCircular4,
          ),
          disabledBackgroundColor: theme.disabledColor,
        ),
        child: isWaitingLoginRequest
            ? const SizedBox(
                height: 24,
                width: 24,
                child: RepaintBoundary(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              )
            : Text(
                localizations.login,
                style: theme.textTheme.labelMedium!
                    .copyWith(fontSize: 20, color: Colors.white),
              ),
      );
}
