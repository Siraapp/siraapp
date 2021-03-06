import 'package:app/repositories/application_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'application.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  final ApplicationRepository applicationRepository;

  ApplicationBloc({@required this.applicationRepository})
      : assert(applicationRepository != null),
        super(ApplicationLoading());

  @override
  Stream<ApplicationState> mapEventToState(ApplicationEvent event) async* {
    if (event is ApplicationLoad) {
      yield ApplicationLoading();
      try {
        // final applications =
            // await applicationRepository.getApplications(event.user.id);
        // yield ApplicationLoadSuccess(applications);
      } catch (_) {
        yield ApplicationOperationFailure();
      }
    }

    if (event is ApplicationCreate) {
      try {
        await applicationRepository.createApplication(event.application);
        final applications = await applicationRepository
            .getApplications(event.application.companyId);
        yield ApplicationLoadSuccess(applications);
      } catch (_) {
        yield ApplicationOperationFailure();
      }
    }

    if (event is ApplicationUpdate) {
      try {
        await applicationRepository.updateApplication(event.application);
        final applications = await applicationRepository
            .getApplications(event.application.companyId);
        yield ApplicationLoadSuccess(applications);
      } catch (_) {
        yield ApplicationOperationFailure();
      }
    }

    if (event is ApplicationDelete) {
      try {
        await applicationRepository.deleteApplication(event.application.id);
        final applications = await applicationRepository
            .getApplications(event.application.companyId);
        yield ApplicationLoadSuccess(applications);
      } catch (_) {
        yield ApplicationOperationFailure();
      }
    }
  }
}
