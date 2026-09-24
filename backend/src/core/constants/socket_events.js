const ROOM_SOCKET_EVENTS = Object.freeze({
    CREATE_ROOM: 'create_room',
    ROOM_CREATED: 'room_created',

    JOIN_ROOM: 'join_room',
    ROOM_JOINED: 'room_joined',

    PLAYER_JOINED: 'player_joined',
    PLAYER_LEFT: 'player_left',

    ROOM_UPDATED: 'room_updated',

    MAKE_MOVE: 'make_move',
    MOVE_MADE: 'move_made',

    SUBMIT_GAME_RESULT: 'submit_game_result',
    ROUND_RESULT: 'round_result',

    TOGGLE_READY: 'toggle_ready',
    READY_UPDATED: 'ready_updated',

    GAME_STARTED: 'game_started',
    GAME_ENDED: 'game_ended',

    ROOM_ERROR: 'room_error',
    GAME_ERROR: 'game_error',
});

module.exports = {
    ROOM_SOCKET_EVENTS,
};