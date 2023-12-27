import 'package:authcrypt/models/addPasswordModel.dart';
import 'package:authcrypt/provider/addPasswordProvider.dart';
import 'package:authcrypt/services/databaseService.dart';
import 'package:authcrypt/utils/masterPassUtil.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:local_auth/local_auth.dart';

import 'package:provider/provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';

class ViewPassword extends StatefulWidget {
  const ViewPassword({super.key});

  @override
  State<ViewPassword> createState() => _ViewPasswordState();
}

class _ViewPasswordState extends State<ViewPassword> {
  final focus = FocusNode();
  final titlecontroller = TextEditingController();
  final urlcontroller = TextEditingController();
  final usernamecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final notescontroller = TextEditingController();
  bool isObsecured = true;

  bool didAuthenticate = false;

  bool decrypt = false;
  String decrypted = "";
  late encrypt.Encrypted encrypted;
  String keyString = "";
  String encryptedString = "";
  String decryptedString = "";
  String masterPassString = "";

  final GlobalKey<FormState> _viewPasswordformKey = GlobalKey<FormState>();

  void validate(BuildContext context) async {
    final FormState form = _viewPasswordformKey.currentState!;

    if (form.validate()) {
      final newPass = AddPasswordModel(
        addeddate: context.read<AddPasswordProvider>().addeddate,
        title: titlecontroller.text.trim(),
        url: urlcontroller.text.trim(),
        username: usernamecontroller.text.trim(),
        password: passwordcontroller.text.trim(),
        notes: notescontroller.text.trim(),
        id: context.read<AddPasswordProvider>().id,
      );
      context
          .read<DatabaseService>()
          .updatePassword(
            password: newPass,
          )
          .then((value) {
        context.read<AddPasswordProvider>().userPasswords = [];

        context.read<AddPasswordProvider>().fatchdata;
      });

      Navigator.pop(context);
    } else {
      const snackbar = SnackBar(
        content: Text("Please enter all required fields."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  void initState() {
    usernamecontroller.text = context.read<AddPasswordProvider>().username;
    titlecontroller.text = context.read<AddPasswordProvider>().title;
    urlcontroller.text = context.read<AddPasswordProvider>().url!;
    passwordcontroller.text = context.read<AddPasswordProvider>().password;
    notescontroller.text = context.read<AddPasswordProvider>().notes!;
    super.initState();
    authenticate();
  }

  authenticate() async {
    var localAuth = LocalAuthentication();
    didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Authenticate to view password!',
        options: AuthenticationOptions(biometricOnly: true, stickyAuth: true));
  }

  Future<bool> _getBiometricStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('biometricEnabled') ?? false;
  }

  Future<bool> _authenticateWithBiometrics() async {
    var localAuth = LocalAuthentication();

    try {
      // Check if biometric authentication is available
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;

      if (canCheckBiometrics) {
        // Authenticate the user
        bool didAuthenticate = await localAuth.authenticate(
            localizedReason: 'Authenticate with biometrics',
            options:
                AuthenticationOptions(biometricOnly: true, stickyAuth: true));

        return didAuthenticate;
      } else {
        // Biometric authentication is not available
        return false;
      }
    } catch (e) {
      print('Error during biometric authentication: $e');
      return false;
    }
  }

  @override
  void dispose() {
    titlecontroller.dispose();
    urlcontroller.dispose();
    usernamecontroller.dispose();
    passwordcontroller.dispose();
    notescontroller.dispose();
    focus.dispose();
    super.dispose();
  }

  void loadMasterPassword() async {
    String? password = await SharedPreferencesUtils.getMasterPassword();
    setState(() {
      masterPassString = password!;
    });
  }

  encryptPass(String text) {
    keyString = masterPassString;
    if (keyString.length < 32) {
      int count = 32 - keyString.length;
      for (var i = 0; i < count; i++) {
        keyString += ".";
      }
    }
    final key = encrypt.Key.fromUtf8(keyString);
    final plainText = text;
    final iv = encrypt.IV.fromLength(16);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final e = encrypter.encrypt(plainText, iv: iv);
    encryptedString = e.base64.toString();

    print("Original: " + plainText);
    print("Encrpted: " + encryptedString);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.read<AddPasswordProvider>().title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.copy,
            ),
            onPressed: () {
              Clipboard.setData(
                ClipboardData(
                  text: context.read<AddPasswordProvider>().password,
                ),
              ).then(
                (value) {
                  return ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password copied to clipboard'),
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_forever_outlined,
            ),
            onPressed: () {
              context.read<AddPasswordProvider>().deletePassword();
              context.read<AddPasswordProvider>().userPasswords = [];
              context.read<AddPasswordProvider>().fatchdata;
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.07,
          ),
          child: Form(
            key: _viewPasswordformKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      'Title ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
                TextFormField(
                  controller: titlecontroller,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator:
                      RequiredValidator(errorText: 'Title is required').call,
                  decoration: const InputDecoration(
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                const Text(
                  'URL',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextFormField(
                  controller: urlcontroller,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                const Row(
                  children: [
                    Text(
                      'Username ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
                TextFormField(
                  controller: usernamecontroller,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator:
                      RequiredValidator(errorText: 'User Name is required')
                          .call,
                  decoration: const InputDecoration(
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                const Row(
                  children: [
                    Text(
                      'Password ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  obscureText: isObsecured,
                  controller: passwordcontroller,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(focus);
                  },
                  validator:
                      RequiredValidator(errorText: 'Password is required').call,
                  decoration: InputDecoration(
                    filled: true,
                    suffix: InkWell(
                      child: Icon(
                        isObsecured ? Icons.visibility : Icons.visibility_off,
                      ),
                      onTap: () async {
                        // bool isBiometricEnabled = await _getBiometricStatus();
                        // if (isBiometricEnabled) {
                        //   bool isAuthenicated =
                        //       await _authenticateWithBiometrics();
                        //   if (!isAuthenicated) {
                        //     return;
                        //   }
                        // }
                        if (didAuthenticate) {
                          setState(() {
                            isObsecured = !isObsecured;
                          });
                        }
                        // encryptData();
                        // encryptPass(passwordcontroller.text.toString());
                        // setState(() {
                        //   isObsecured = !isObsecured;
                        // });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                const Text(
                  'Notes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextFormField(
                  maxLines: 2,
                  focusNode: focus,
                  controller: notescontroller,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      validate(context);
                    },
                    child: const Text('Update'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
