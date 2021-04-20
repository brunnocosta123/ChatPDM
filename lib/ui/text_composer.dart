import 'dart:io';

import 'package:chatpdm/helpers/firebase_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  TextEditingController controller = TextEditingController();
  FireBaseHelper helper = FireBaseHelper();
  bool _isCompose = false;
  bool _isSendingImage = false;

  void _reset() {
    controller.clear();
    setState(() {
      _isCompose = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(
        children: [
          _isSendingImage ? LinearProgressIndicator() : Container(),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: () async {
                  PickedFile pfile = await ImagePicker.platform
                      .pickImage(source: ImageSource.camera);
                  if (pfile != null) {
                    File file = File(pfile.path);
                    setState(() {
                      _isSendingImage = true;
                    });
                    helper.sendImage(file).then((value) {
                      setState(() {
                        _isSendingImage = false;
                      });
                    });
                  }
                },
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration.collapsed(
                      hintText: "Enviar uma Mensagem"),
                  onChanged: (text) {
                    setState(() {
                      _isCompose = text.isNotEmpty;
                    });
                  },
                  onSubmitted: (text) {
                    helper.sendMenssage(text);
                    _reset();
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: _isCompose
                    ? () {
                        helper.sendMenssage(controller.text);
                        _reset();
                      }
                    : null,
              )
            ],
          )
        ],
      ),
    );
  }
}
