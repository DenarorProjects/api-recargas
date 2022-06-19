import { Router } from "express";
import { methods as phoneController } from "../controllers/phone.controller";
import { methods as userController } from "../controllers/user.controller";

const router = Router();

router.get('/user/:dni', userController.getPhonesByUser);
router.post('/user', userController.addUser);

router.get('/phone/:num', phoneController.getPhoneByNumPhone);
router.get('/phone', phoneController.getPhones);
router.post('/recarga', phoneController.updateBalanceMovil);
router.post('/phone', phoneController.addPhoneNumber);

export default router;
