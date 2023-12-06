import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jumnah/screens/webview_example_screen.dart';

class Welcome extends StatelessWidget {
  Welcome({Key? key}) : super(key: key);
  Rx<TextEditingController> url = TextEditingController(text: 'https://www.jumnah.com').obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(padding: EdgeInsets.all(30),
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                return TextFormField(
                  controller:url.value,
                  decoration: InputDecoration(
                    hintText: 'Enter Url',
                  ),
                );
              }),
              SizedBox(height: 10,),
              ElevatedButton(
                  onPressed: (){
                Get.to(WebviewExampleScreen(url: url.value.text.toString()));
              }, child: Text('Go')),
            ],
          ),),
      ),
    );
  }
}
