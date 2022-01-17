class GeneralResponse {
  var data;
  bool status;
  String error;
  GeneralResponse(
      {this.data, this.error = "Something went wrong", this.status = false});

  @override
  String toString() =>
      'GeneralResponse(data: $data, status: $status, error: $error)';
}
