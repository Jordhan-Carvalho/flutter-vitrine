import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageCapture extends StatefulWidget {
  final Function addFile;
  final File existingImage;
  final int existingIndex;
  ImageCapture(
      {Key key, @required this.addFile, this.existingImage, this.existingIndex})
      : super(key: key);

  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _imageFile;
  int _fileIndex;
  @override
  void initState() {
    super.initState();
    if (widget.existingImage != null && widget.existingIndex != null) {
      setState(() {
        _imageFile = widget.existingImage;
        _fileIndex = widget.existingIndex;
      });
    }
  }

  Future<void> _pickImage(ImageSource imgSrc) async {
    var image = await ImagePicker.pickImage(
      source: imgSrc,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 97,
    );

    if (image == null) {
      return;
    }
    if (_fileIndex == null) {
      _fileIndex = widget.addFile(file: image);
    } else {
      widget.addFile(file: image, fileIndex: _fileIndex);
    }

    setState(() {
      _imageFile = image;
    });
  }

  // Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      maxHeight: 512,
      maxWidth: 512,
      androidUiSettings: AndroidUiSettings(
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Theme.of(context).primaryColor,
          toolbarTitle: 'Modificar foto'),
    );

    widget.addFile(file: cropped ?? _imageFile, fileIndex: _fileIndex);
    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        if (_imageFile != null)
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: _cropImage,
              ),
              IconButton(
                icon: Icon(
                  Icons.insert_photo,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        Container(
          width: 120,
          height: 90,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          child: _imageFile != null
              ? Image.file(
                  _imageFile,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Adicionar foto',
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.photo_camera),
                          onPressed: () => _pickImage(ImageSource.camera),
                          color: Theme.of(context).primaryColor,
                          iconSize: 35,
                        ),
                        IconButton(
                          icon: Icon(Icons.photo_library),
                          onPressed: () => _pickImage(ImageSource.gallery),
                          color: Theme.of(context).primaryColor,
                          iconSize: 35,
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
