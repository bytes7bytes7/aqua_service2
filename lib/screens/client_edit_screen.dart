import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_repository/client_repository.dart';

import '../blocs/blocs.dart';
import '../widgets/ask_bottom_sheet.dart';
import '../widgets/widgets.dart';
import '../constants/routes.dart' as constant_routes;

class ClientEditScreen extends StatelessWidget {
  const ClientEditScreen({
    Key? key,
    required this.client,
  }) : super(key: key);

  final Client client;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AvatarBloc>(
          create: (context) {
            return AvatarBloc();
          },
        ),
        BlocProvider<GalleryBloc>(
          create: (context) {
            return GalleryBloc();
          },
        ),
      ],
      child: _Body(client),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body(
    this.client, {
    Key? key,
  }) : super(key: key);

  final Client client;

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  late final ValueNotifier<bool> isCreated;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final Client modClient;
  late Client savedClient;

  late final ClientBloc clientBloc;
  late final AvatarBloc avatarBloc;
  late final GalleryBloc galleryBloc;

  @override
  void initState() {
    isCreated = ValueNotifier(widget.client.id != null);
    modClient = Client.from(widget.client);
    savedClient = Client.from(widget.client);
    clientBloc = context.read<ClientBloc>();
    avatarBloc = context.read<AvatarBloc>();
    galleryBloc = context.read<GalleryBloc>();
    avatarBloc.add(AvatarLoadEvent(modClient.avatarPath));
    galleryBloc.add(GalleryLoadEvent(modClient.images));
    super.initState();
  }

  @override
  void dispose() {
    isCreated.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: BackAppBar(
          title: 'Клиент',
          onExit: () {
            modClient.id ??= savedClient.id;
            if (modClient != savedClient) {
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
              modClient.id ??= savedClient.id;
              savedClient = Client.from(modClient);
              if (savedClient.id != null) {
                clientBloc.add(ClientUpdateEvent(savedClient));
              } else {
                isCreated.value = true;
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
                            modClient.avatarPath = state.path;
                            if (state.avatar.isEmpty) {
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
                            avatarBloc.add(AvatarSelectEvent());
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
                            if (modClient.avatarPath.isEmpty) {
                              ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(
                                  showInfoSnackBar(
                                    context: context,
                                    info: 'Нет фото',
                                  ),
                                );
                            } else {
                              showAskBottomSheet(
                                context: context,
                                title:
                                    'Вы действительно хотите удалить аватарку?',
                                text1: 'Отмена',
                                text2: 'Удалить',
                                onPressed1: () {
                                  Navigator.of(context).pop();
                                },
                                onPressed2: () {
                                  avatarBloc.add(AvatarDeleteEvent());
                                  Navigator.of(context).pop();
                                },
                              );
                            }
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
                        // TODO: add next & previous dates
                        Text(
                          'Послед. дата: ' + modClient.previousDate,
                          style: theme.textTheme.bodyText1,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'След. дата: ' + modClient.nextDate,
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
                  ),
                  PaddingTextFormField(
                    title: 'Телефон',
                    value: modClient.phone,
                    isPhoneNumber: true,
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      modClient.phone = value;
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
                  ),
                  PaddingTextFormField(
                    title: 'Адрес',
                    value: modClient.address,
                    onChanged: (String value) {
                      modClient.address = value;
                    },
                  ),
                  PaddingTextFormField(
                    title: 'Объем аквариума',
                    value: modClient.volume,
                    onChanged: (String value) {
                      modClient.volume = value;
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
                    ),
                  ),
                  Container(
                    height: 230,
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: BlocBuilder<GalleryBloc, GalleryState>(
                      builder: (BuildContext context, GalleryState state) {
                        if (state is GalleryLoadingState) {
                          return const SizedBox.shrink();
                        } else if (state is GalleryDataState) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: List.generate(
                                state.gallery.length + 1,
                                (index) {
                                  if (index == state.gallery.length) {
                                    return Container(
                                      margin: const EdgeInsets.only(
                                        left: 0,
                                        right: 20.0,
                                      ),
                                      width: size.width * 0.7,
                                      child: OutlinedButton(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_photo_alternate,
                                              color: theme.shadowColor,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Добавить фото',
                                              style: theme.textTheme.subtitle1,
                                            )
                                          ],
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          primary: theme.primaryColor,
                                          side: BorderSide(
                                            color: theme.disabledColor,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                        onPressed: () async {
                                          galleryBloc.add(
                                            GalleryAddEvent(modClient.images),
                                          );
                                        },
                                      ),
                                    );
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        constant_routes.gallery,
                                        arguments: {
                                          'galleryBloc': galleryBloc,
                                          'images': modClient.images,
                                          'index': index,
                                        },
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        left: index == 0 ? 20.0 : 0,
                                        right: 20.0,
                                      ),
                                      width: size.width * 0.7,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        border: Border.all(
                                          color: theme.disabledColor,
                                        ),
                                        color: theme.scaffoldBackgroundColor,
                                        image: DecorationImage(
                                          image:
                                              MemoryImage(state.gallery[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        } else {
                          // TODO: try GalleryErrorState
                          return Container(
                            margin: const EdgeInsets.only(
                              left: 0,
                              right: 20.0,
                            ),
                            width: size.width * 0.7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.warning_amber_outlined,
                                  color: theme.errorColor,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Ошибка',
                                  style: theme.textTheme.subtitle1!
                                      .copyWith(color: theme.errorColor),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: isCreated,
                    builder: (context, bool value, _) {
                      if (!value) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                                if (savedClient.id != null) {
                                  clientBloc
                                      .add(ClientDeleteEvent(savedClient));
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
