class SocketResponse {
    static success(data) {
        return {
            success: true,
            data,
        };
    }

    static error(message) {
        return {
            success: false,
            message,
        };
    }
}

module.exports = SocketResponse;