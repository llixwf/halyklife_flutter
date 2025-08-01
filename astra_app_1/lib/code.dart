import 'package:astra_app_1/bottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:async';
import 'token_manager.dart';

class Code extends StatefulWidget {
  const Code({super.key});

  @override
  _CodeState createState() => _CodeState();
}

class _CodeState extends State<Code> {
  final List<String> _input = [];
  bool _showKeyboard = false;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    bool didAuthenticate = false;
    try {
      didAuthenticate = await auth.authenticate(
        localizedReason: 'Пожалуйста, используйте отпечаток пальца',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {}
    if (!didAuthenticate) {
      await Future.delayed(Duration(seconds: 5));
      setState(() => _showKeyboard = true);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomnNavigation()),
      );
    }
  }

  void _handleKeyTap(String value) async {
    String? savedPin = await PinStorage.getPin();
    setState(() {
      if (value == 'back') {
        if (_input.isNotEmpty) _input.removeLast();
      } else if (_input.length < 4) {
        _input.add(value);
        if (_input.length == 4) {
          if (_input.join() == savedPin) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BottomnNavigation()),
            );
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Не правильный код")));
            _input.clear();
          }
        }
      }
    });
  }

  Widget _buildDot(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6),
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: index < _input.length ? Colors.black : Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildNumber(String number, {IconData? icon}) {
    return GestureDetector(
      onTap: () => _handleKeyTap(number),
      child: Container(
        alignment: Alignment.center,
        child:
            icon != null
                ? Icon(icon, size: 28)
                : Text(
                  number,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
                ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset("images/Logo-3.png"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: 160),
          Text(
            "Код быстрого доступа",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, _buildDot),
          ),
          SizedBox(height: 18),
          Text(
            "Забыли ПИН-код?",
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
          SizedBox(height: 100),
          Expanded(
            child:
                _showKeyboard
                    ? GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 1.6,
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      children: [
                        for (var i = 1; i <= 9; i++) _buildNumber(i.toString()),
                        Image.asset(
                          "images/Face ID.png",
                          width: 10,
                          height: 10,
                        ),
                        _buildNumber('0'),
                        _buildNumber('back', icon: Icons.backspace_outlined),
                      ],
                    )
                    : Center(
                      child: Icon(
                        Icons.fingerprint,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
