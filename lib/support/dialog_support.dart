import 'package:flutter/material.dart';

mixin DialogSupport {
  void loading(BuildContext context, String msg) {
    showDialog(
      context: context,
      barrierDismissible: false, // không thể ẩn bằng cách bấm ra ngoài
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          contentPadding: const EdgeInsets.all(16),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  width: 30,
                  height: 30,
                  child: Center(child: CircularProgressIndicator())),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(msg),
              )
            ],
          ),
        );
      },
    );
  }
  void pop(BuildContext context){
    Navigator.of(context).pop();
  }
  Future<void> showSuccess(BuildContext context, String msg) async {
    AlertDialog dialog = AlertDialog(
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      contentPadding: const EdgeInsets.all(16),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.check_circle,color: Colors.green,size: 40,),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(msg),
          )
        ],
      ),
    );
    showDialog(context: context, builder: (_) => dialog);
    await Future.delayed(Duration(milliseconds: 800));
    pop(context);
  }
  Future<void> showAlertMessage(BuildContext context,String msg) async{
    AlertDialog dialog = new AlertDialog(
      content: Text(msg),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            pop(context);
          },
        ),
      ],
    );
    showDialog(context: context, builder: (_) => dialog);
  }
}
