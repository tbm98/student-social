import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr/qr.dart';

import 'qr_painter.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({
    this.data,
    this.size,
    this.padding = const EdgeInsets.all(70),
    this.backgroundColor,
    this.onError,
    this.gapless = false,
  });

  final Color backgroundColor;
  final EdgeInsets padding;
  final double size;
  final QrError onError;
  final bool gapless;
  final String data;

  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  String _data;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo QR CODE'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double widgetSize =
                    widget.size ?? constraints.biggest.shortestSide;
                double w = MediaQuery.of(context).size.width;
                return Hero(
                  tag: 'button_current_day',
                  child: Container(
                    width: w,
                    height: w,
                    color: const Color(0xFFFFFFFF),
                    child: Padding(
                      padding: widget.padding,
                      child: CustomPaint(
                        painter: QrPainter(
                            data: _data,
                            color: const Color(0xFF000000),
                            version: 4,
                            errorCorrectionLevel: QrErrorCorrectLevel.L,
                            gapless: widget.gapless,
                            onError: widget.onError),
                      ),
                    ),
                  ),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        style: const TextStyle(color: Colors.green),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Trống';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          setState(() {
                            _data = value;
                          });
                        },
                        decoration: InputDecoration(
                            hintText: 'Nhập nội dung cần tạo',
                            labelText: 'Tạo QR Code',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 32,
                              ),
                              onPressed: () {
                                if (formKey.currentState.validate()) {
                                  formKey.currentState.save();
                                }
                              },
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Mã hiện tại',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Text(_data,
                style: const TextStyle(fontSize: 20, color: Colors.green))
          ],
        ),
      ),
    );
  }
}
