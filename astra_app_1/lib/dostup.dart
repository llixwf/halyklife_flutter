import 'package:astra_app_1/sec_dostup.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'token_manager.dart';

class Dostup extends StatefulWidget {
  const Dostup({super.key});

  @override
  _Dostup createState() => _Dostup();
}

class _Dostup extends State<Dostup> {
  final List<String> _input = [];

  final LocalAuthentication auth = LocalAuthentication();

  void _handleKeyTap(String value) {
    setState(() {
      if (value == 'back') {
        if (_input.isNotEmpty) _input.removeLast();
      } else if (_input.length < 4) {
        _input.add(value);
        if (_input.length == 4) {
          PinStorage.savePin(_input.join());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dostup2()),
          );
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
            "Придумайте код",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, _buildDot),
          ),
          SizedBox(height: 100),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 1.6,
              padding: EdgeInsets.symmetric(horizontal: 40),
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: [
                for (var i = 1; i <= 9; i++) _buildNumber(i.toString()),
                Image.asset("images/Face ID.png", width: 10, height: 10),
                _buildNumber('0'),
                _buildNumber('back', icon: Icons.backspace_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
