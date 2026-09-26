export const ROOM_SOCKET_EVENTS = {
    CONNECT_ROOM: "connect_room",
    ROOM_CONNECTED: "room_connected",

    MAKE_MOVE: "make_move",
    MOVE_MADE: "move_made",

    SUBMIT_GAME_RESULT: "submit_game_result",
    ROUND_RESULT: "round_result",

    TOGGLE_READY: "toggle_ready",
    READY_UPDATED: "ready_updated",

    ROOM_ERROR: "room_error",
} as const;