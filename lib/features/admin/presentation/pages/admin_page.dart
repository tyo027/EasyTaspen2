import 'package:easy/core/common/pages/auth_page.dart';
import 'package:easy/core/common/widgets/button_widget.dart';
import 'package:easy/core/common/widgets/text_field_widget.dart';
import 'package:easy/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  static route() => MaterialPageRoute(builder: (context) => const AdminPage());

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _usernameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: "Admin",
      stackedWidget: (context, user) {
        return [
          Form(
            key: formKey,
            child: TextFieldWidget(
              'Username',
              controller: _usernameController,
              validator: (value) {
                if (value?.isEmpty ?? true) return "Username Kosong";
                return null;
              },
            ),
          ),
        ];
      },
      bottomWidget: (context, user) {
        return ButtonWidget.primary(
          'Buka Akses',
          onPressed: () {
            if (!formKey.currentState!.validate()) return;

            context
                .read<AdminBloc>()
                .add(ResetUserDevice(_usernameController.text));
          },
        );
      },
      builder: (context, user) {
        return [
          BaseConsumer<AdminBloc, dynamic>(
            onSuccess: (data) {
              showSnackBar(
                context,
                "Akses berhasil dibuka!",
                indicatorColor: Colors.green,
              );
            },
            builder: (context, state) {
              return const SizedBox();
            },
          )
        ];
      },
    );
  }
}
