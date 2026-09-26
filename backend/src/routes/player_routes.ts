import { Router } from "express";

import PlayerController from "../controllers/player_controller.js";

const playerRoutes = Router();

playerRoutes.post(
    "/initialize",
    PlayerController.initialize.bind(PlayerController),
);

playerRoutes.get(
    "/:playerId",
    PlayerController.getPlayer.bind(PlayerController),
);

playerRoutes.get(
    "/",
    PlayerController.getPlayers.bind(PlayerController),
);

playerRoutes.delete(
    "/:playerId",
    PlayerController.deletePlayer.bind(PlayerController),
);

export default playerRoutes;