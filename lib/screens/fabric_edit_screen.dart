import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fabric_repository/fabric_repository.dart';

import '../services/number_format_service.dart' as number_format_service;
import '../blocs/blocs.dart';
import '../widgets/ask_bottom_sheet.dart';
import '../widgets/widgets.dart';

class FabricEditScreen extends StatefulWidget {
  const FabricEditScreen({
    Key? key,
    required this.fabric,
  }) : super(key: key);

  final Fabric fabric;

  @override
  State<FabricEditScreen> createState() => _FabricEditScreenState();
}

class _FabricEditScreenState extends State<FabricEditScreen> {
  late final ValueNotifier<bool> isCreated;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final ValueNotifier<String> profitNotifier;
  late final Fabric modFabric;
  late Fabric savedFabric;

  @override
  void initState() {
    isCreated = ValueNotifier(widget.fabric.id != null);
    profitNotifier = ValueNotifier(number_format_service.getRidOfZero(
        (widget.fabric.retailPrice - widget.fabric.purchasePrice).toString()));
    modFabric = Fabric.from(widget.fabric);
    savedFabric = Fabric.from(widget.fabric);
    super.initState();
  }

  @override
  void dispose() {
    isCreated.dispose();
    profitNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fabricBloc = context.read<FabricBloc>();

    void calcProfit() {
      if (modFabric.retailPrice == 0) {
        try {
          double value = modFabric.purchasePrice;
          if (value != 0) {
            profitNotifier.value = (-(value.abs())).toString();
          } else {
            profitNotifier.value = value.toString();
          }
        } catch (e) {
          profitNotifier.value = '?';
        }
      } else {
        try {
          profitNotifier.value =
              (modFabric.retailPrice - modFabric.purchasePrice).toString();
        } catch (e) {
          profitNotifier.value = '?';
        }
      }
      if (profitNotifier.value != '?') {
        profitNotifier.value =
            number_format_service.getRidOfZero(profitNotifier.value);
      }
    }

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
                onPressed1: () {
                  Navigator.of(context).pop();
                },
                onPressed2: () {
                  Navigator.of(context).pop();
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
              savedFabric = Fabric.from(modFabric);
              if (savedFabric.id != null) {
                fabricBloc.add(FabricUpdateEvent(savedFabric));
              } else {
                isCreated.value = true;
                fabricBloc.add(FabricAddEvent(savedFabric));
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                  value: number_format_service
                      .getRidOfZero(modFabric.retailPrice.toString()),
                  keyboardType: TextInputType.number,
                  onChanged: (String value) {
                    try {
                      modFabric.retailPrice =
                          double.parse(value.replaceAll(',', '.'));
                    } catch (e) {
                      modFabric.retailPrice = 0.0;
                    }
                    calcProfit();
                  },
                  validator: (String? value) {
                    value = value?.replaceAll(',', '.');
                    if (value != null) {
                      try {
                        double.parse(value);
                      } catch (e) {
                        return 'Не число';
                      }
                    }
                  },
                ),
                PaddingTextFormField(
                  title: 'Закупочная цена',
                  value: number_format_service
                      .getRidOfZero(modFabric.purchasePrice.toString()),
                  keyboardType: TextInputType.number,
                  onChanged: (String value) {
                    try {
                      modFabric.purchasePrice =
                          double.parse(value.replaceAll(',', '.'));
                    } catch (e) {
                      modFabric.purchasePrice = 0.0;
                    }
                    calcProfit();
                  },
                  validator: (String? value) {
                    value = value?.replaceAll(',', '.');
                    if (value != null) {
                      try {
                        double.parse(value);
                      } catch (e) {
                        return 'Не число';
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
                    if(!value){
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                      child: WideButton(
                        isPositive: false,
                        title: 'Удалить',
                        onPressed: () {
                          showAskBottomSheet(
                            context: context,
                            title:
                            'Вы действительно хотите удалить материал?',
                            text1: 'Отмена',
                            text2: 'Удалить',
                            onPressed1: () {
                              Navigator.pop(context);
                            },
                            onPressed2: () {
                              if (savedFabric.id != null) {
                                fabricBloc.add(FabricDeleteEvent(savedFabric));
                              }
                              Navigator.pop(context);
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
