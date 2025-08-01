import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasRec extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset("images/Logo-3.png"),
        centerTitle: true,
        iconTheme: IconThemeData(size: 30),
        backgroundColor: Colors.transparent,
      ),
      body: Recovery(),
    );
  }
}

class Recovery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 100),
          Text(
            "Восстановление пароля",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          Container(
            width: 400,
            child: TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20, top: 18, bottom: 18),
                labelText: "Телефон",
                labelStyle: TextStyle(fontSize: 18),
                hintStyle: TextStyle(color: Color(0xFF909090), fontSize: 17),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Container(
            width: 400,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/PasRec2");
              },
              child: Text(
                "Отправить код подтверждения",
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
    );
  }
}

class PasRec2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
              "Восстановление пароля",
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
                  Navigator.pushNamed(context, "/next");
                },
                child: Text(
                  "Отправить код подтверждения",
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
