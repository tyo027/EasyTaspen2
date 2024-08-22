import 'package:easy/core/common/pages/auth_page.dart';
import 'package:easy/core/common/widgets/button_widget.dart';
import 'package:easy/core/common/widgets/text_field_widget.dart';
import 'package:easy/core/utils/month_picker_dialog.dart';
import 'package:easy/features/payslip/presentation/bloc/payslip_bloc.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class PayslipPage extends StatefulWidget {
  const PayslipPage({super.key});

  static route() =>
      MaterialPageRoute(builder: (context) => const PayslipPage());

  @override
  State<PayslipPage> createState() => _PayslipPageState();
}

class _PayslipPageState extends State<PayslipPage> {
  DateTimeRange? _timeRange;
  final TextEditingController _timeRangeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: "Slip Gaji",
      stackedWidget: (context, user) {
        return [
          TextFieldWidget(
            'Bulan',
            controller: _timeRangeController,
            onTap: _bulanTap,
          ),
        ];
      },
      bottomWidget: (context, user) {
        return ButtonWidget.primary(
          "Cari",
          onPressed: _timeRange != null
              ? () {
                  context
                      .read<PayslipBloc>()
                      .add(LoadPayslip(nik: user.nik, range: _timeRange!));
                }
              : null,
        );
      },
      builder: (context, user) {
        return [
          BaseConsumer<PayslipBloc, String>(
            builder: (context, state) {
              if (state is SuccessState<String>) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Html(
                    data: state.data
                        .replaceAll('<br>', '')
                        .replaceAll(RegExp(r'-+'), '<br/><br/>')
                        .replaceAll('||', '<br>')
                        .replaceAll('|', '<br>')
                        .replaceAll('..', '')
                        .replaceAll(
                            RegExp(r'(<br\s*/?>\s*){2,}'), '<br/><br/>'),
                  ),
                );
              }
              return const Gap(0);
            },
          )
        ];
      },
    );
  }

  void _bulanTap(context) {
    monthPickerDialog(
      context,
      initialDate: _timeRange?.start ??
          (DateTime.now().day < 25
              ? DateTime.now().add(const Duration(days: -25))
              : DateTime.now()),
      lastDate: DateTime.now().day < 25
          ? DateTime.now().add(const Duration(days: -25))
          : DateTime.now(),
      onSelected: (selectedMonth) {
        if (selectedMonth != null) {
          _timeRangeController.text =
              DateFormat("MMMM yyyy", 'id_ID').format(selectedMonth);

          setState(() {
            _timeRange = DateTimeRange(
              start: selectedMonth.copyWith(day: 1),
              end: selectedMonth
                  .copyWith(day: 1)
                  .copyWith(month: selectedMonth.month + 1, day: 0),
            );
          });
        }
      },
    );
  }
}
