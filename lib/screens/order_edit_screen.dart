import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:order_repository/order_repository.dart';
import 'package:image_repository/image_repository.dart';

import '../blocs/blocs.dart';
import '../widgets/widgets.dart';
import '../constants/sizes.dart' as constant_sizes;
import '../constants/tooltips.dart' as constant_tooltips;
import '../constants/routes.dart' as constant_routes;

class OrderEditScreen extends StatelessWidget {
  const OrderEditScreen({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AvatarBloc>(
      create: (context) {
        return AvatarBloc(const ImageRepository());
      },
      child: _Body(order: order),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  late final SlidableController slidableController;
  late final ValueNotifier<bool> isCreated;
  late final ValueNotifier<bool> isDone;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final ValueNotifier<String> profitNotifier;
  late final Order modOrder;
  late Order savedOrder;

  late final OrderBloc orderBloc;
  late final AvatarBloc avatarBloc;

  @override
  void initState() {
    slidableController = SlidableController();
    isCreated = ValueNotifier(widget.order.id != null);
    isDone = ValueNotifier(widget.order.done);
    modOrder = Order.from(widget.order);
    savedOrder = Order.from(widget.order);
    profitNotifier = ValueNotifier((widget.order.price -
            widget.order.expenses +
            widget.order.fabrics.fold(0,
                (prev, curr) => prev + curr.retailPrice - curr.purchasePrice))
        .toString());
    orderBloc = context.read<OrderBloc>();
    avatarBloc = context.read<AvatarBloc>();
    avatarBloc.add(AvatarLoadEvent(modOrder.client.avatarPath));
    super.initState();
  }

  @override
  void dispose() {
    isCreated.dispose();
    isDone.dispose();
    profitNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void calcProfit() {
      try {
        profitNotifier.value = (modOrder.price -
                modOrder.expenses +
                modOrder.fabrics.fold(
                    0,
                    (prev, curr) =>
                        prev + curr.retailPrice - curr.purchasePrice))
            .toString();
      } catch (e) {
        profitNotifier.value = '?';
      }
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: BackAppBar(
          title: 'Заказ',
          onExit: () {
            modOrder.id ??= savedOrder.id;
            if (modOrder != savedOrder) {
              showAskBottomSheet(
                context: context,
                title: 'Выйти?\nИзменения будут утеряны!',
                text1: 'Отмена',
                text2: 'Выйти',
                onPressed2: () {
                  Navigator.of(context).pop();
                },
              );
            } else {
              Navigator.of(context).pop();
            }
          },
          onSave: () {
            final currentState = _formKey.currentState;
            if (modOrder.client.id == null) {
              // TODO: add client validator
            }
            if (currentState != null &&
                currentState.validate() &&
                modOrder.client.id != null) {
              currentState.save();
              modOrder.id ??= savedOrder.id;
              savedOrder = Order.from(modOrder);
              if (savedOrder.id != null) {
                orderBloc.add(OrderUpdateEvent(savedOrder));
              } else {
                isCreated.value = true;
                orderBloc.add(OrderAddEvent(savedOrder));
              }
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  showInfoSnackBar(
                    context: context,
                    info: 'Сохранено!',
                  ),
                );
            }
          },
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  // TODO: add navigation to ClientEditScreen
                  FloatingLabelContainer(
                    text: 'Клиент',
                    style: theme.textTheme.bodyText1!
                        .copyWith(color: theme.disabledColor),
                    padding: const EdgeInsets.symmetric(
                      horizontal: constant_sizes.textFieldHorPadding,
                      vertical: constant_sizes.textFieldVerPadding,
                    ),
                    backgroundColor: theme.scaffoldBackgroundColor,
                    borderColor: theme.disabledColor,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: theme.primaryColor,
                          radius: constant_sizes.avatarRadius,
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: BlocBuilder<AvatarBloc, AvatarState>(
                              builder:
                                  (BuildContext context, AvatarState state) {
                                if (state is AvatarLoadingState) {
                                  return const SizedBox.shrink();
                                } else if (state is AvatarDataState) {
                                  modOrder.client.avatarPath = state.path;
                                  if (state.avatar.isEmpty) {
                                    return CircleAvatar(
                                      backgroundColor:
                                          theme.scaffoldBackgroundColor,
                                      radius: constant_sizes.avatarRadius,
                                      child: Text(
                                        modOrder.client.name.isNotEmpty
                                            ? modOrder.client.name[0]
                                            : '?',
                                        style: theme.textTheme.headline1!
                                            .copyWith(
                                                color: theme.primaryColor),
                                      ),
                                    );
                                  }
                                  return CircleAvatar(
                                    backgroundColor:
                                        theme.scaffoldBackgroundColor,
                                    radius: constant_sizes.avatarRadius,
                                    foregroundImage: MemoryImage(state.avatar),
                                  );
                                } else {
                                  return CircleAvatar(
                                    backgroundColor:
                                        theme.scaffoldBackgroundColor,
                                    radius: constant_sizes.avatarRadius / 2,
                                    child: Icon(
                                      Icons.warning_amber_outlined,
                                      color: theme.errorColor,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              modOrder.client.name,
                              style: theme.textTheme.headline2,
                            ),
                            Text(
                              modOrder.client.city,
                              style: theme.textTheme.subtitle1,
                            ),
                          ],
                        ),
                        const Spacer(),
                        // IconButton does not work here
                        Tooltip(
                          message: constant_tooltips.choose,
                          child: RawMaterialButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            padding: const EdgeInsets.all(8),
                            constraints:
                                const BoxConstraints(minWidth: 0, minHeight: 0),
                            splashColor: theme.disabledColor.withOpacity(0.3),
                            child: Icon(
                              Icons.edit,
                              color: theme.primaryColor,
                            ),
                            shape: const CircleBorder(),
                            onPressed: () {
                              // TODO: add navigation to ClientsScreen
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  PaddingTextFormField(
                    title: 'Стоимость',
                    value:
                        (modOrder.price != 0) ? modOrder.price.toString() : '',
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      try {
                        modOrder.price = int.parse(value);
                      } catch (e) {
                        modOrder.price = 0;
                      }
                      calcProfit();
                    },
                    validator: (String? value) {
                      if (value != null && value.isNotEmpty) {
                        try {
                          int.parse(value);
                        } catch (e) {
                          return 'Ошибка';
                        }
                      }
                    },
                  ),
                  PaddingTextFormField(
                    title: 'Затраты',
                    value: (modOrder.expenses != 0)
                        ? modOrder.expenses.toString()
                        : '',
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      try {
                        modOrder.expenses = int.parse(value);
                      } catch (e) {
                        modOrder.expenses = 0;
                      }
                      calcProfit();
                    },
                    validator: (String? value) {
                      if (value != null && value.isNotEmpty) {
                        try {
                          int.parse(value);
                        } catch (e) {
                          return 'Ошибка';
                        }
                      }
                    },
                  ),
                  PaddingTextFormField(
                    title: 'Дата',
                    value: '',
                    // modOrder.date
                    suffixIconType: SuffixIconType.calendar,
                    onChanged: (String value) {
                      // modOrder.date = value;
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Заполните поле';
                      }
                    },
                  ),
                  FloatingLabelContainer(
                    text: 'Материалы',
                    style: theme.textTheme.bodyText1!
                        .copyWith(color: theme.disabledColor),
                    borderColor: theme.disabledColor,
                    backgroundColor: theme.scaffoldBackgroundColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: constant_sizes.textFieldVerPadding,
                      vertical: constant_sizes.textFieldVerPadding,
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount:
                            modOrder.fabrics.length + (modOrder.done ? 0 : 1),
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: theme.disabledColor,
                            thickness: 1,
                            height: 1,
                          );
                        },
                        itemBuilder: (context, index) {
                          if (index == 0 && !modOrder.done) {
                            // TODO: if (fabrics.length == 0) { place "Add button" on the center }
                            return Material(
                              color: theme.scaffoldBackgroundColor,
                              child: InkWell(
                                splashColor: theme.disabledColor,
                                onTap: () async {
                                  await Navigator.of(context).pushNamed(
                                    constant_routes.fabrics,
                                    arguments: {
                                      'selected': modOrder.fabrics,
                                    },
                                  );
                                  setState(() {
                                    // update fabrics
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Добавить',
                                        style: theme.textTheme.headline2!
                                            .copyWith(
                                                color: theme.primaryColor),
                                      ),
                                      Icon(
                                        Icons.add,
                                        color: theme.primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          return FabricListItem(
                            fabric: modOrder
                                .fabrics[index - (modOrder.done ? 0 : 1)],
                            controller: slidableController,
                          );
                        },
                      ),
                    ),
                  ),
                  PaddingTextFieldNotifier(
                    title: 'Прибыль',
                    notifier: profitNotifier,
                  ),
                  SizedBox(
                    height: 300,
                    child: PaddingTextFormField(
                      title: 'Комментарий',
                      value: modOrder.comment,
                      keyboardType: TextInputType.multiline,
                      expands: true,
                      onChanged: (String value) {
                        modOrder.comment = value;
                      },
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: isDone,
                    builder: (context, bool value, _) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: WideButton(
                          isActive: isCreated.value && !value,
                          isPositive: true,
                          title: isDone.value ? 'Завершен' : 'Завершить',
                          onPressed: () {
                            showAskBottomSheet(
                              context: context,
                              title:
                                  'Завершить заказ?\nОтменить действие будет невозможно!',
                              text1: 'Отмена',
                              text2: 'Завершить',
                              onPressed2: () {
                                isDone.value = true;
                                if (savedOrder.id != null) {
                                  orderBloc.add(OrderArchiveEvent(savedOrder));
                                }
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: isCreated,
                    builder: (context, bool value, _) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: WideButton(
                          isActive: value,
                          isPositive: false,
                          title: 'Удалить',
                          onPressed: () {
                            showAskBottomSheet(
                              context: context,
                              title: 'Вы действительно хотите удалить заказ?',
                              text1: 'Отмена',
                              text2: 'Удалить',
                              onPressed2: () {
                                if (savedOrder.id != null) {
                                  orderBloc.add(OrderDeleteEvent(savedOrder));
                                }
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
