// import 'package:flutter/material.dart';

// import '../models/service.dart';

// class ServiceDetailScreen extends StatelessWidget {
//   static const routeName = '/meal-detail';

//   final Function toggleFav;
//   final Function isFav;

//   ServiceDetailScreen(this.toggleFav, this.isFav);

// // those methods could be separeted widgets
//   Widget _buildSectionTitle(String text, BuildContext ctx) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: Text(
//         text,
//         style: Theme.of(ctx).textTheme.title,
//       ),
//     );
//   }

//   Widget _buildContainer(Widget child) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       margin: const EdgeInsets.all(10),
//       padding: const EdgeInsets.all(10),
//       height: 150,
//       width: 300,
//       child: child,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final meal = ModalRoute.of(context).settings.arguments as Service;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(meal.title),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Container(
//               height: 300,
//               width: double.infinity,
//               child: Image.network(
//                 meal.imageUrl,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             _buildSectionTitle("Ingredients", context),
//             _buildContainer(
//               ListView.builder(
//                 itemCount: meal.ingredients.length,
//                 itemBuilder: (ctx, index) {
//                   return Card(
//                     color: Theme.of(context).accentColor,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 5,
//                         horizontal: 10,
//                       ),
//                       child: Text(meal.ingredients[index]),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             _buildSectionTitle("Steps", context),
//             _buildContainer(
//               ListView.builder(
//                 itemCount: meal.steps.length,
//                 itemBuilder: (ctx, index) {
//                   return Column(
//                     children: <Widget>[
//                       ListTile(
//                         leading: CircleAvatar(
//                           child: Text('# ${index + 1}'),
//                         ),
//                         title: Text(meal.steps[index]),
//                       ),
//                       Divider(),
//                     ],
//                   );
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(isFav(meal.id) ? Icons.star : Icons.star_border),
//         onPressed: () => toggleFav(meal.id),
//       ),
//     );
//   }
// }
