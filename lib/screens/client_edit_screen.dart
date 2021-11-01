import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_repository/client_repository.dart';

import '../blocs/blocs.dart';
import '../custom/always_bouncing_scroll_physics.dart';
import '../global/show_ask_bottom_sheet.dart';
import '../widgets/widgets.dart';

class ClientEditScreen extends StatefulWidget {
  const ClientEditScreen({
    Key? key,
    required this.client,
  }) : super(key: key);

  final Client client;

  @override
  State<ClientEditScreen> createState() => _ClientEditScreenState();
}

class _ClientEditScreenState extends State<ClientEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final clientBloc = context.read<ClientBloc>();
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: BackAppBar(
          title: 'Клиент',
          onPressed: () {
            final currentState = _formKey.currentState;
            if (currentState != null && currentState.validate()) {
              currentState.save();
              if (widget.client.id != null) {
                clientBloc.add(ClientUpdateEvent(widget.client));
              } else {
                clientBloc.add(ClientAddEvent(widget.client));
              }
            }
          },
        ),
        body: SingleChildScrollView(
          physics: const AlwaysBouncingScrollPhysics(),
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
                      child: CircleAvatar(
                        backgroundColor: theme.scaffoldBackgroundColor,
                        radius: 45,
                        child: Text(
                          widget.client.name.isNotEmpty
                              ? widget.client.name[0]
                              : '?',
                          style: theme.textTheme.headline3!
                              .copyWith(color: theme.primaryColor),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width * 0.3,
                        child: OutlinedButton(
                          child: FittedBox(
                            child: Text(
                              'Изменить',
                              style: theme.textTheme.bodyText1,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            primary: theme.primaryColor,
                            side: BorderSide(
                              color: theme.disabledColor,
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                topLeft: Radius.circular(20),
                                topRight: Radius.zero,
                                bottomRight: Radius.zero,
                              ),
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.3,
                        child: OutlinedButton(
                          child: FittedBox(
                            child: Text(
                              'Удалить',
                              style: theme.textTheme.bodyText1,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            primary: theme.primaryColor,
                            side: BorderSide(
                              color: theme.disabledColor,
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.zero,
                                topLeft: Radius.zero,
                              ),
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 27.0,
                      vertical: 16.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.disabledColor,
                      ),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Послед. дата: 03.09.21',
                          style: theme.textTheme.bodyText1,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'След. дата: 08.10.21',
                          style: theme.textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                  PaddingTextFormField(
                    title: 'Имя',
                    value: widget.client.name,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Заполните поле';
                      }
                    },
                    onSave: (String? value) {
                      widget.client.name = value ?? '';
                    },
                  ),
                  PaddingTextFormField(
                    title: 'Телефон',
                    value: widget.client.phone,
                    isPhoneNumber: true,
                    keyboardType: TextInputType.number,
                    onSave: (String? value) {
                      widget.client.phone = value ?? '';
                    },
                  ),
                  PaddingTextFormField(
                    title: 'Город',
                    value: widget.client.city,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Заполните поле';
                      }
                    },
                    onSave: (String? value) {
                      widget.client.city = value ?? '';
                    },
                  ),
                  PaddingTextFormField(
                    title: 'Адрес',
                    value: widget.client.address,
                    onSave: (String? value) {
                      widget.client.address = value ?? '';
                    },
                  ),
                  PaddingTextFormField(
                    title: 'Объем аквариума',
                    value: widget.client.volume,
                    onSave: (String? value) {
                      widget.client.volume = value ?? '';
                    },
                  ),
                  SizedBox(
                    height: 300,
                    child: PaddingTextFormField(
                      title: 'Комментарий',
                      value: widget.client.comment,
                      keyboardType: TextInputType.multiline,
                      expands: true,
                      onSave: (String? value) {
                        widget.client.comment = value ?? '';
                      },
                    ),
                  ),
                  Container(
                    height: 200,
                    padding: const EdgeInsets.only(top: 30.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: List.generate(4, (index) {
                          return Container(
                            margin: EdgeInsets.only(
                              left: index == 0 ? 20.0 : 0,
                              right: 20.0,
                            ),
                            width: size.width * 0.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: theme.disabledColor,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
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
                              title: 'Вы действительно хотите удалить клиента?',
                              text1: 'Отмена',
                              text2: 'Удалить',
                              onPressed1: () {
                                Navigator.pop(context);
                              },
                              onPressed2: () {
                                if (widget.client.id != null) {
                                  clientBloc
                                      .add(ClientDeleteEvent(widget.client));
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
      ),
    );
  }
}
