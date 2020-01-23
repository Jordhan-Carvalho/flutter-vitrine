import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Uploader extends StatefulWidget {
  final File file;
  Uploader({Key key, this.file}) : super(key: key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://vitrine-3da15.appspot.com');
  StorageUploadTask _uploadTask;

  void _startUpload() async {
    String filePath = 'images/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
    var downurl = await (await _uploadTask.onComplete).ref.getDownloadURL();
    print(downurl.toString());
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      // Manage the task state and event subscription with a StreamBuilder
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (_, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Expanded(
              child: Column(
                children: [
                  if (_uploadTask.isComplete) Text('🎉🎉🎉'),

                  if (_uploadTask.isPaused)
                    FlatButton(
                      child: Icon(Icons.play_arrow),
                      onPressed: _uploadTask.resume,
                    ),

                  if (_uploadTask.isInProgress)
                    FlatButton(
                      child: Icon(Icons.pause),
                      onPressed: _uploadTask.pause,
                    ),

                  // Progress bar
                  LinearProgressIndicator(value: progressPercent),
                  Text('${(progressPercent * 100).toStringAsFixed(2)} % '),
                ],
              ),
            );
          });
    } else {
      return FlatButton.icon(
        label: Text('Upload'),
        icon: Icon(Icons.cloud_upload),
        onPressed: _startUpload,
      );
    }
  }
}

// ONLY AUTH USERS BUCKET
// service firebase.storage {
//   match /b/{bucket}/o {
//     match /{allPaths=**} {
//       allow read, write: if request.auth != null;
//     }
//   }
// }
