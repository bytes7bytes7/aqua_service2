import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fabric_repository/fabric_repository.dart';

import '../blocs/blocs.dart';
import '../widgets/widgets.dart';
import '../constants/routes.dart' as constant_routes;
import '../constants/tooltips.dart' as constant_tooltips;

class FabricsScreen extends StatelessWidget {
  const FabricsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fabricBloc = context.read<FabricBloc>();
    return Scaffold(
      appBar: const DrawerAppBar(title: 'Материалы'),
      drawer: const AppDrawer(),
      body: BlocBuilder<FabricBloc, FabricState>(
        builder: (BuildContext context, FabricState state) {
          if (state is FabricLoadingState) {
            return const LoadingCircle();
          } else if (state is FabricDataState) {
            return _FabricList(
              items: state.fabrics,
            );
          } else if (state is FabricErrorState) {
            return ErrorCard(
              error: state.error,
              onRefresh: () {
                fabricBloc.add(FabricLoadEvent());
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: BlocBuilder<FabricBloc, FabricState>(
        builder: (BuildContext context, FabricState state) {
          if (state is FabricDataState) {
            return FloatingActionButton(
              tooltip: constant_tooltips.add,
              backgroundColor: theme.primaryColor,
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  constant_routes.fabricEdit,
                  arguments: {
                    'fabric' : Fabric(),
                  },
                );
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class _FabricList extends StatefulWidget {
  const _FabricList({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List items;

  @override
  __FabricListState createState() => __FabricListState();
}

class __FabricListState extends State<_FabricList> {
  late final SlidableController slidableController;

  @override
  void initState() {
    slidableController = SlidableController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fabricBloc = context.read<FabricBloc>();
    if (widget.items.isEmpty) {
      return Center(
        child: Text(
          'Пусто',
          style: theme.textTheme.bodyText1,
        ),
      );
    }
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: widget.items.length,
      separatorBuilder: (context, index) {
        return Divider(
          color: theme.disabledColor,
          thickness: 1,
          height: 1,
        );
      },
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return Slidable(
          key: Key('${item.hashCode}'),
          controller: slidableController,
          direction: Axis.horizontal,
          actionPane: const SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: FabricCard(
            fabric: item,
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Удалить',
              color: theme.errorColor,
              icon: Icons.delete,
              onTap: () {
                showAskBottomSheet(
                  context: context,
                  title: 'Вы действительно хотите удалить материал?',
                  text1: 'Отмена',
                  text2: 'Удалить',
                  onPressed2: () {
                    fabricBloc.add(FabricDeleteEvent(item));
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
