import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fabric_repository/fabric_repository.dart';

import '../blocs/blocs.dart';
import '../widgets/ask_bottom_sheet.dart';
import '../widgets/widgets.dart';

class FabricEditScreen extends StatefulWidget {
  const FabricEditScreen({
    Key? key,
    required this.fabric,
    this.fabricsNotifier,
  }) : super(key: key);

  final Fabric fabric;
  final ValueNotifier<List<Fabric>>? fabricsNotifier;

  @override
  State<FabricEditScreen> createState() => _FabricEditScreenState();
}

class _FabricEditScreenState extends State<FabricEditScreen> {
  late final ValueNotifier<bool> isCreated;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final ValueNotifier<String> profitNotifier;
  late final Fabric modFabric;
  late Fabric savedFabric;

  late final FabricBloc fabricBloc;
  late final OrderBloc orderBloc;

  @override
  void initState() {
    isCreated = ValueNotifier(widget.fabric.id != null);
    profitNotifier = ValueNotifier(
        (widget.fabric.retailPrice - widget.fabric.purchasePrice).toString());
    modFabric = Fabric.from(widget.fabric);
    savedFabric = Fabric.from(widget.fabric);
    fabricBloc = context.read<FabricBloc>();
    orderBloc = context.read<OrderBloc>();
    super.initState();
  }

  @override
  void dispose() {
    isCreated.dispose();
    profitNotifier.dispose();
    super.dispose();
  }

  void calcProfit() {
    try {
      profitNotifier.value =
          (modFabric.retailPrice - modFabric.purchasePrice).toString();
    } catch (e) {
      profitNotifier.value = '?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: BackAppBar(
          title: 'Материал',
          onExit: () {
            modFabric.id ??= savedFabric.id;
            if (modFabric != savedFabric) {
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
            if (currentState != null && currentState.validate()) {
              currentState.save();
              modFabric.id ??= savedFabric.id;
              savedFabric = Fabric.from(modFabric);
              if (savedFabric.id != null) {
                fabricBloc.add(FabricUpdateEvent(savedFabric));
              } else {
                isCreated.value = true;
                fabricBloc.add(FabricAddEvent(savedFabric));
              }
              // TODO: try to delete (=archive) fabric while editing order
              // update info on OrderEditScreen
              if (widget.fabricsNotifier != null) {
                int length = widget.fabricsNotifier!.value.length;
                widget.fabricsNotifier!.value
                    .removeWhere((e) => e.id == modFabric.id);
                widget.fabricsNotifier!.value.addAll(List.generate(
                    length - widget.fabricsNotifier!.value.length,
                    (index) => modFabric));
                widget.fabricsNotifier!.value = List.from(widget.fabricsNotifier!.value);
              }
              // update OrderBloc
              orderBloc.add(OrderLoadEvent());
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                PaddingTextFormField(
                  title: 'Название',
                  value: modFabric.title,
                  onChanged: (String value) {
                    modFabric.title = value;
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Заполните поле';
                    }
                  },
                ),
                PaddingTextFormField(
                  title: 'Розничная цена',
                  value: (modFabric.retailPrice != 0)
                      ? modFabric.retailPrice.toString()
                      : '',
                  keyboardType: TextInputType.number,
                  onChanged: (String value) {
                    try {
                      modFabric.retailPrice = int.parse(value);
                    } catch (e) {
                      modFabric.retailPrice = 0;
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
                  title: 'Закупочная цена',
                  value: (modFabric.purchasePrice != 0)
                      ? modFabric.purchasePrice.toString()
                      : '',
                  keyboardType: TextInputType.number,
                  onChanged: (String value) {
                    try {
                      modFabric.purchasePrice = int.parse(value);
                    } catch (e) {
                      modFabric.purchasePrice = 0;
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
                PaddingTextFieldNotifier(
                  title: 'Прибыль',
                  notifier: profitNotifier,
                ),
                // TODO: find a way how to place this button at the bottom
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
                            title: 'Вы действительно хотите удалить материал?',
                            text1: 'Отмена',
                            text2: 'Удалить',
                            onPressed2: () {
                              if (savedFabric.id != null) {
                                fabricBloc.add(FabricDeleteEvent(savedFabric));
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
    );
  }
}
