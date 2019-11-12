import 'package:flutter/widgets.dart';
import 'package:qr/qr.dart';
import 'package:flutter/material.dart';

import 'qr_painter.dart';

class QRCodeView extends StatefulWidget {
  QRCodeView({
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
  _QRCodeViewState createState() => _QRCodeViewState();
}

class _QRCodeViewState extends State<QRCodeView> {
  String _data;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tạo QR CODE'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[

              LayoutBuilder(
                builder: (context, constraints) {
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
                        child: new CustomPaint(
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
                padding: const EdgeInsets.only(top: 8,left: 16,right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Form(
                        key: formKey,
                        child: TextFormField(
                          key: Key('inputqrcode'),
                          style: TextStyle(color: Colors.green),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Trống';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              _data = value;
                            });
                          },
                          decoration: InputDecoration(
                              hintText: 'Nhập nội dung cần tạo',
                              labelText: 'Tạo QR Code',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              suffixIcon: IconButton(
                                key: Key('qrtao'),
                                  icon: Icon(Icons.arrow_forward), onPressed: (){
                                if (formKey.currentState.validate()) {
                                  formKey.currentState.save();
                                }
                              })
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Mã hiện tại',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Text(_data, key: Key('qrketqua'),style: TextStyle(fontSize: 20))
            ],
          ),
        ),
      ),
    );
  }
}
