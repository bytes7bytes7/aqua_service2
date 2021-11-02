import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fabric_repository/fabric_repository.dart';

import '../services/number_format_service.dart' as number_format_service;
import '../blocs/blocs.dart';
import '../custom/always_bouncing_scroll_physics.dart';
import '../global/show_ask_bottom_sheet.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final ValueNotifier<String> retailPriceNotifier;
  late final ValueNotifier<String> purchasePriceNotifier;
  late final ValueNotifier<String> profitNotifier;

  @override
  void initState() {
    retailPriceNotifier = ValueNotifier(number_format_service
        .getRidOfZero(widget.fabric.retailPrice.toString()));
    purchasePriceNotifier = ValueNotifier(number_format_service
        .getRidOfZero(widget.fabric.purchasePrice.toString()));
    profitNotifier = ValueNotifier(number_format_service.getRidOfZero(
        (widget.fabric.retailPrice - widget.fabric.purchasePrice).toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fabricBloc = context.read<FabricBloc>();

    void calcProfit() {
      if (retailPriceNotifier.value.isEmpty &&
          purchasePriceNotifier.value.isEmpty) {
        profitNotifier.value = '0';
      } else if (retailPriceNotifier.value.isEmpty) {
        try {
          double value =
              double.parse(purchasePriceNotifier.value.replaceAll(',', '.'));
          if (value != 0) {
            profitNotifier.value = (-(value.abs())).toString();
          } else {
            profitNotifier.value = value.toString();
          }
        } catch (e) {
          profitNotifier.value = '?';
        }
      } else if (purchasePriceNotifier.value.isEmpty) {
        try {
          profitNotifier.value =
              double.parse(retailPriceNotifier.value.replaceAll(',', '.'))
                  .abs()
                  .toString();
        } catch (e) {
          profitNotifier.value = '?';
        }
      } else {
        try {
          profitNotifier.value =
              (double.parse(retailPriceNotifier.value.replaceAll(',', '.')) -
                      double.parse(
                          purchasePriceNotifier.value.replaceAll(',', '.')))
                  .toString();
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
          onSave: () {
            final currentState = _formKey.currentState;
            if (currentState != null && currentState.validate()) {
              currentState.save();
              if (widget.fabric.id != null) {
                fabricBloc.add(FabricUpdateEvent(widget.fabric));
              } else {
                fabricBloc.add(FabricAddEvent(widget.fabric));
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
          physics: const AlwaysBouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                PaddingTextFormField(
                  title: 'Название',
                  value: widget.fabric.title,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Заполните поле';
                    }
                  },
                  onSave: (String? value) {
                    widget.fabric.title = value ?? '';
                  },
                ),
                PaddingTextFormField(
                  title: 'Розничная цена',
                  value: retailPriceNotifier.value,
                  keyboardType: TextInputType.number,
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
                  onSave: (String? value) {
                    if (value != null) {
                      widget.fabric.retailPrice = double.parse(
                          retailPriceNotifier.value.replaceAll(',', '.'));
                    } else {
                      widget.fabric.retailPrice = 0.0;
                    }
                  },
                  onChanged: (String value) {
                    retailPriceNotifier.value = value;
                    calcProfit();
                  },
                ),
                PaddingTextFormField(
                  title: 'Закупочная цена',
                  value: purchasePriceNotifier.value,
                  keyboardType: TextInputType.number,
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
                  onSave: (String? value) {
                    if (value != null) {
                      widget.fabric.purchasePrice = double.parse(
                          purchasePriceNotifier.value.replaceAll(',', '.'));
                    } else {
                      widget.fabric.purchasePrice = 0.0;
                    }
                  },
                  onChanged: (String value) {
                    purchasePriceNotifier.value = value;
                    calcProfit();
                  },
                ),
                PaddingTextFieldNotifier(
                  title: 'Прибыль',
                  notifier: profitNotifier,
                ),
                // TODO: find a way how to place this button at the bottom
                if (widget.fabric.id != null)
                  Builder(
                    builder: (context) {
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
                                if (widget.fabric.id != null) {
                                  fabricBloc
                                      .add(FabricDeleteEvent(widget.fabric));
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
