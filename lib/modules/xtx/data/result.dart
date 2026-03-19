part of '../../../recollect_utils.dart';

sealed class Result<T> {
  const Result();

  factory Result.success(T value) => Success(value);

  factory Result.failure(T error) => Failure(error);
}

final class Success<T> extends Result<T> {
  final T? value;

  const Success([this.value]);
}

final class Failure<T> extends Result<T> {
  final T? error;

  const Failure([this.error]);
}
