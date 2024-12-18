
const express = require('express');
const paymentController = require('../controllers/paymentController.js');
const router = express.Router();

router.post('/add', paymentController.addPayment);
router.put('/updateTheQuantityToPayment', paymentController.updateTheQuantityToPayment);



router.delete('/deleteFromCartProductThatPaied', paymentController.deleteFromCartProductThatPaied);
router.get('/checkTheQuantityToPayment', paymentController.checkTheQuantityToPayment);

router.get('/AllPayment', paymentController.AllPayment);



router.put('/updatestatus', paymentController.updatestatus);




//router.get('/calculateallprice', paymentController.calculateallprice);








module.exports = router;