import 'package:equatable/equatable.dart';

import '../../domain/entities/farm_notification.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

final class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

final class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

final class NotificationsReady extends NotificationsState {
  const NotificationsReady(this.items);

  final List<FarmNotification> items;

  @override
  List<Object?> get props => [items];
}

final class NotificationsFailure extends NotificationsState {
  const NotificationsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
