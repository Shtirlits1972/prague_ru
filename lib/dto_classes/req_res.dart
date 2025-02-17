class ReqRes<T> {
  int status = 0;
  String message = '';
  T? model = null;

  ReqRes(this.status, this.message, this.model);

  ReqRes.empty() {
    status = 0;
    message = '';
    model = null;
  }

  @override
  String toString() {
    return 'status = $status, message = $message, model = $model';
  }
}
