import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const <Widget>[
          SizedBox(
            child: Image(image: AssetImage('assets/journalpic.png'))
          ),
          Text('Click the \'Add\' icon to get started!', 
            textAlign: TextAlign.center,),
        ],
      ),
    );
  }
}