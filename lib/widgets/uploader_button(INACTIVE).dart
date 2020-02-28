// TODO remove it

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:provider/provider.dart';

// import '../providers/auth.dart';

// class Uploader extends StatefulWidget {
//   final File file;
//   final Function upComplete;
//   final Function getUrl;
//   final String imgName;
//   Uploader(
//       {Key key,
//       this.file,
//       this.upComplete,
//       this.getUrl,
//       @required this.imgName})
//       : super(key: key);

//   @override
//   _UploaderState createState() => _UploaderState();
// }

// class _UploaderState extends State<Uploader> {
//   final FirebaseStorage _storage =
//       FirebaseStorage(storageBucket: 'gs://vitrine-3da15.appspot.com');
//   StorageUploadTask _uploadTask;

//   void _startUpload() async {
//     final userId = Provider.of<Auth>(context, listen: false).userId;
//     //regex to remove all white spaces
//     String filePath =
//         'images/$userId/${widget.imgName.replaceAll(new RegExp(r"\s+\b|\b\s"), "")}';
//     print(filePath);

//     setState(() {
//       _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
//     });
//     var downurl = await (await _uploadTask.onComplete).ref.getDownloadURL();

//     widget.upComplete();
//     widget.getUrl(downurl.toString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_uploadTask != null) {
//       // Manage the task state and event subscription with a StreamBuilder
//       return StreamBuilder<StorageTaskEvent>(
//           stream: _uploadTask.events,
//           builder: (_, snapshot) {
//             var event = snapshot?.data?.snapshot;

//             double progressPercent = event != null
//                 ? event.bytesTransferred / event.totalByteCount
//                 : 0;

//             return Container(
//               width: 100,
//               height: 50,
//               child: Column(
//                 children: [
//                   if (_uploadTask.isComplete)
//                     FittedBox(child: Text('Completado!')),

//                   if (_uploadTask.isPaused)
//                     Expanded(
//                       child: FlatButton(
//                         child: Icon(
//                           Icons.play_arrow,
//                           color: Theme.of(context).iconTheme.color,
//                         ),
//                         onPressed: _uploadTask.resume,
//                       ),
//                     ),

//                   if (_uploadTask.isInProgress)
//                     Expanded(
//                       child: FlatButton(
//                         child: Icon(
//                           Icons.pause,
//                           color: Theme.of(context).iconTheme.color,
//                         ),
//                         onPressed: _uploadTask.pause,
//                       ),
//                     ),

//                   // Progress bar
//                   LinearProgressIndicator(value: progressPercent),
//                   FittedBox(
//                       child: Text(
//                           '${(progressPercent * 100).toStringAsFixed(2)} % ')),
//                 ],
//               ),
//             );
//           });
//     } else {
//       return FlatButton.icon(
//         label: Text('Confirmar'),
//         icon: Icon(
//           Icons.cloud_upload,
//           color: Theme.of(context).iconTheme.color,
//         ),
//         onPressed: _startUpload,
//       );
//     }
//   }
// }

// ONLY AUTH USERS BUCKET
// service firebase.storage {
//   match /b/{bucket}/o {
//     match /{allPaths=**} {
//       allow read, write: if request.auth != null;
//     }
//   }
// }
