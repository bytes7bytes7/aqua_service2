import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_repository/client_repository.dart';

import '../services/image_service.dart';
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
  late final Client modClient;
  late Client savedClient;
  late final ValueNotifier<bool> avatarNotifier;

  @override
  void initState() {
    modClient = Client.from(widget.client);
    savedClient = Client.from(widget.client);
    avatarNotifier = ValueNotifier(true);
    super.initState();
  }

  @override
  void dispose() {
    avatarNotifier.dispose();
    super.dispose();
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
          onExit: () {
            print(savedClient.id == modClient.id);
            print(savedClient.avatarPath == modClient.avatarPath);
            print(savedClient.name == modClient.name);
            print(savedClient.city == modClient.city);
            print(savedClient.address == modClient.address);
            print(savedClient.phone == modClient.phone);
            print(savedClient.volume == modClient.volume);
            print(savedClient.previousDate == modClient.previousDate);
            print(savedClient.nextDate == modClient.nextDate);
            print(savedClient.images == modClient.images);
            print(savedClient.comment == modClient.comment);
            print('images: ${widget.client.images}');
            print('images: ${modClient.images}');
            if (modClient != savedClient) {
              showNoYesAlertDialog(
                context: context,
                title: 'Выйти?',
                description: 'Несохраненные изменения будут утеряны!',
                lBtnText: 'Отмена',
                rBtnText: 'Выйти',
                lBtnPressed: () {
                  Navigator.of(context).pop();
                },
                rBtnPressed: () {
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
              savedClient = Client.from(modClient);
              if (modClient.id != null) {
                clientBloc.add(ClientUpdateEvent(savedClient));
              } else {
                clientBloc.add(ClientAddEvent(savedClient));
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
                      child: ValueListenableBuilder(
                        valueListenable: avatarNotifier,
                        builder: (context, _, __) {
                          // TODO: image blinks when alert dialog shows up
                          return FutureBuilder(
                            future:
                                ImageService.loadImage(modClient.avatarPath),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data!.isNotEmpty) {
                                return CircleAvatar(
                                  backgroundColor:
                                      theme.scaffoldBackgroundColor,
                                  radius: 45,
                                  foregroundImage: MemoryImage(snapshot.data),
                                );
                              }
                              return CircleAvatar(
                                backgroundColor: theme.scaffoldBackgroundColor,
                                radius: 45,
                                child: Text(
                                  modClient.name.isNotEmpty
                                      ? modClient.name[0]
                                      : '?',
                                  style: theme.textTheme.headline3!
                                      .copyWith(color: theme.primaryColor),
                                ),
                              );
                            },
                          );
                        },
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
                          onPressed: () async {
                            String path = await ImageService.pickImage();
                            if (path.isNotEmpty) {
                              modClient.avatarPath = path;
                              avatarNotifier.value = !avatarNotifier.value;
                            }
                          },
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
                          onPressed: () {
                            modClient.avatarPath = '';
                            avatarNotifier.value = !avatarNotifier.value;
                          },
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
                    value: modClient.name,
                    onChanged: (String value) {
                      modClient.name = value;
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Заполните поле';
                      }
                    },
                    onSave: (String? value) {
                      modClient.name = value ?? '';
                    },
                  ),
                  PaddingTextFormField(
                    title: 'Телефон',
                    value: modClient.phone,
                    isPhoneNumber: true,
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      modClient.phone = value;
                    },
                    onSave: (String? value) {
                      modClient.phone = value ?? '';
                    },
                  ),
                  PaddingTextFormField(
                    title: 'Город',
                    value: modClient.city,
                    onChanged: (String value) {
                      modClient.city = value;
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Заполните поле';
                      }
                    },
                    onSave: (String? value) {
                      modClient.city = value ?? '';
                    },
                  ),
                  PaddingTextFormField(
                    title: 'Адрес',
                    value: modClient.address,
                    onChanged: (String value) {
                      modClient.address = value;
                    },
                    onSave: (String? value) {
                      modClient.address = value ?? '';
                    },
                  ),
                  PaddingTextFormField(
                    title: 'Объем аквариума',
                    value: modClient.volume,
                    onChanged: (String value) {
                      modClient.volume = value;
                    },
                    onSave: (String? value) {
                      modClient.volume = value ?? '';
                    },
                  ),
                  SizedBox(
                    height: 300,
                    child: PaddingTextFormField(
                      title: 'Комментарий',
                      value: modClient.comment,
                      keyboardType: TextInputType.multiline,
                      expands: true,
                      onChanged: (String value) {
                        modClient.comment = value;
                      },
                      onSave: (String? value) {
                        modClient.comment = value ?? '';
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
                  if (modClient.id != null)
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
                                    'Вы действительно хотите удалить клиента?',
                                text1: 'Отмена',
                                text2: 'Удалить',
                                onPressed1: () {
                                  Navigator.pop(context);
                                },
                                onPressed2: () {
                                  if (modClient.id != null) {
                                    clientBloc
                                        .add(ClientDeleteEvent(modClient));
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
