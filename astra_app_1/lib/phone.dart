import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneVer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset("images/Logo-3.png"),
        iconTheme: IconThemeData(size: 30),
        backgroundColor: Colors.transparent,
      ),
      body: Verefication(),
    );
  }
}

class Verefication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 100),
            Text(
              "Подтверждение номера телефона",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              textAlign: TextAlign.center,
              "Введите код подтверждения, который мы \n отправили Вам на указанный номер",
              style: TextStyle(fontSize: 16, color: Color(0xFF909090)),
            ),
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Form(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [FormNum(), FormNum(), FormNum(), FormNum()],
                ),
              ),
            ),
            Text(
              "Отправить код повторно",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Color(0xFF909090),
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(height: 35),
            Container(
              width: 400,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/Code");
                },
                child: Text(
                  "Отправить",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 241, 129, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FormNum extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 80,
      child: TextFormField(
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          } else if (value.length == 0) {
            FocusScope.of(context).previousFocus();
          }
        },
        style: Theme.of(context).textTheme.headlineMedium,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          hintText: "0",
          hintStyle: TextStyle(color: Color(0x66111111)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.orange, width: 2),
          ),
        ),
      ),
    );
  }
}

// class Code extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Image.asset("images/Logo-3.png"),
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.transparent,
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             SizedBox(height: 100),
//             Text(
//               "Код быстрого доступа",
//               style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
