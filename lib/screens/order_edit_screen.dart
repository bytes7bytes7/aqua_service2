import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository.dart';
import 'package:client_repository/client_repository.dart';
import 'package:fabric_repository/fabric_repository.dart';
import 'package:image_repository/image_repository.dart';

import '../blocs/blocs.dart';
import '../widgets/widgets.dart';

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
    final size = MediaQuery.of(context).size;

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
            orderBloc.add(OrderAddEvent(Order(
              client: Client(id: 1),
              price: 123,
              fabrics: [
                Fabric(id: 1),
                Fabric(id: 2),
              ],
            )));
            return;
            final currentState = _formKey.currentState;
            if (currentState != null && currentState.validate()) {
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: CircleAvatar(
                      backgroundColor: theme.primaryColor,
                      radius: 46,
                      child: BlocBuilder<AvatarBloc, AvatarState>(
                        builder: (BuildContext context, AvatarState state) {
                          if (state is AvatarLoadingState) {
                            return const SizedBox.shrink();
                          } else if (state is AvatarDataState) {
                            modOrder.client.avatarPath = state.path;
                            if (state.avatar.isEmpty) {
                              return CircleAvatar(
                                backgroundColor: theme.scaffoldBackgroundColor,
                                radius: 45,
                                child: Text(
                                  modOrder.client.name.isNotEmpty
                                      ? modOrder.client.name[0]
                                      : '?',
                                  style: theme.textTheme.headline3!
                                      .copyWith(color: theme.primaryColor),
                                ),
                              );
                            }
                            return CircleAvatar(
                              backgroundColor: theme.scaffoldBackgroundColor,
                              radius: 45,
                              foregroundImage: MemoryImage(state.avatar),
                            );
                          } else {
                            return CircleAvatar(
                              backgroundColor: theme.scaffoldBackgroundColor,
                              radius: 45,
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
                    value: '', // modOrder.date
                    onChanged: (String value) {
                      // modOrder.date = value;
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Заполните поле';
                      }
                    },
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
                          title: 'Завершить',
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
