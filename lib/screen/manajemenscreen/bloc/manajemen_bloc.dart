import 'package:easy/models/cekstaff.model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'manajemen_event.dart';
part 'manajemen_state.dart';

class ManajemenBloc extends Bloc<ManajemenEvent, ManajemenState> {
  ManajemenBloc()
      : super(const ManajemenState(
          isLoading: true,
          staff: [],
        )) {}
}
