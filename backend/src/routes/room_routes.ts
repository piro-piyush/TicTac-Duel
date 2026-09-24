import { Router } from 'express';

import RoomController from '../controllers/room_controller';

const router = Router();

router.get(
  '/:roomCode',
  RoomController.getRoom,
);

export default router;