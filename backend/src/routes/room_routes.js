const express = require('express');

const RoomController = require('../controllers/room_controller');

const router = express.Router();

router.get(
  '/:roomCode',
  RoomController.getRoom,
);

module.exports = router;