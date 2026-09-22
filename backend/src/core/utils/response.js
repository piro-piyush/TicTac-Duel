class Response {
  static success(res, {
    message = 'Success',
    data = null,
    statusCode = 200,
  } = {}) {
    return res.status(statusCode).json({
      success: true,
      message,
      data,
    });
  }

  static created(res, {
    message = 'Created successfully',
    data = null,
  } = {}) {
    return this.success(res, {
      message,
      data,
      statusCode: 201,
    });
  }

  static error(res, {
    message = 'Something went wrong',
    statusCode = 500,
    errors = null,
  } = {}) {
    return res.status(statusCode).json({
      success: false,
      message,
      errors,
    });
  }

  static badRequest(res, message = 'Bad request', errors = null) {
    return this.error(res, {
      statusCode: 400,
      message,
      errors,
    });
  }

  static unauthorized(res, message = 'Unauthorized') {
    return this.error(res, {
      statusCode: 401,
      message,
    });
  }

  static forbidden(res, message = 'Forbidden') {
    return this.error(res, {
      statusCode: 403,
      message,
    });
  }

  static notFound(res, message = 'Resource not found') {
    return this.error(res, {
      statusCode: 404,
      message,
    });
  }
}

module.exports = Response;