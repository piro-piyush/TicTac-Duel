export const ROOM_SOCKET_EVENTS = {
    CONNECT_ROOM: "connect_room",
    ROOM_CONNECTED: "room_connected",

    PLAYER_JOINED: "player_joined",
    PLAYER_LEFT: "player_left",

    START_GAME: "start_game",
    ROUND_STARTED: "round_started",

    MAKE_MOVE: "make_move",
    MOVE_MADE: "move_made",

    SUBMIT_GAME_RESULT: "submit_game_result",
    ROUND_RESULT: "round_result",

    ROOM_ERROR: "room_error",
} as const;

export const SOCKET_EVENTS = {
    CONNECT: "connect",
    DISCONNECT: "disconnect",
    ERROR: "error",
} as const;