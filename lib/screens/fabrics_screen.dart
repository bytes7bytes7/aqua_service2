import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class FabricsScreen extends StatelessWidget {
  const FabricsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar:  DrawerAppBar(title: 'Материалы'),
      drawer: AppDrawer(),
      body: Center(),
    );
  }
}

// class FabricsScreen extends StatelessWidget {
//   const FabricsScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     void onAdd(Fabric fabric) {
//       context.read<FabricBloc>().add(FabricAddEvent(fabric));
//     }
//
//     void onUpdate(Fabric fabric) {
//       context.read<FabricBloc>().add(FabricUpdateEvent(fabric));
//     }
//
//     void onDelete(Fabric fabric){
//       context.read<FabricBloc>().add(FabricDeleteEvent(fabric));
//     }
//
//     final theme = Theme.of(context);
//     return Scaffold(
//       appBar: const DrawerAppBar(title: 'Материалы'),
//       drawer: const AppDrawer(),
//       body: BlocBuilder<FabricBloc, FabricState>(
//         builder: (BuildContext context, FabricState state) {
//           if (state is FabricLoadingState) {
//             return const LoadingCircle();
//           } else if (state is FabricDataState) {
//             return FabricList(
//               items: state.fabrics,
//               onAdd: onAdd,
//               onUpdate: onUpdate,
//               onDelete: onDelete,
//             );
//           } else if (state is FabricErrorState) {
//             return ErrorCard(
//               error: state.error,
//               onRefresh: () {
//                 context.read<FabricBloc>().add(FabricLoadEvent());
//               },
//             );
//           } else {
//             return const SizedBox.shrink();
//           }
//         },
//       ),
//       floatingActionButton: BlocBuilder<FabricBloc, FabricState>(
//         builder: (BuildContext context, FabricState state) {
//           if (state is FabricDataState) {
//             return FloatingActionButton(
//               backgroundColor: theme.primaryColor,
//               child: const Icon(Icons.add),
//               onPressed: () {
//                 Navigator.of(context).push(
//                   customRoute(
//                     FabricEditScreen(
//                       fabric: Fabric(),
//                       onAdd: onAdd,
//                       onUpdate: onUpdate,
//                       onDelete: onDelete,
//                     ),
//                   ),
//                 );
//               },
//             );
//           } else {
//             return const SizedBox.shrink();
//           }
//         },
//       ),
//     );
//   }
// }
