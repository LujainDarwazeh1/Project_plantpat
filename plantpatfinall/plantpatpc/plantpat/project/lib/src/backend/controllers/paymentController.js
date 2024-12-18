const PaymentRepository = require('../data/database/paymentRepo');

const paymentRepository = new PaymentRepository();



exports.addPayment = (req, res) => {
  paymentRepository
    .addPayment(req, res)
    .then((message) => {
      res.status(201).json({ message });
    })
    .catch((error) => {
      if (!res.headersSent) { 
        res.status(400).json({ message: error });
      }
    });
};

exports.AllPayment = (req, res) => {
  paymentRepository
    .AllPayment()
    .then((results) => {
      res.status(200).json({ data: results });
    })
    .catch((error) => {
      if (!res.headersSent) { 
        res.status(400).json({ message: error.message });
      }
    });
};

exports.updateTheQuantityToPayment = (req, res) => {
  paymentRepository.updateTheQuantityToPayment(req, res)
    .then((message) => {
      console.log(message);
      res.status(201).json({ message }); 
    })
    .catch((error) => {
      res.status(400).json({ message: error.message || 'Failed to update plant quantities' });
    });
};




exports.updatestatus = (req, res) => {
  paymentRepository.updatestatus(req, res)
    .then((message) => {
      console.log(message);
      res.status(200).json({ message });
    })
    .catch((error) => {
      res.status(400).json({ message: error.message || 'Failed to update payment status' });
    });
};




//



exports.deleteFromCartProductThatPaied = (req, res) => {
  const cartIds = req.query.cart_ids;
  const userId = req.query.user_id;


  if (!userId || !cartIds) {
    return res.status(400).json({ error: 'user_id and cart_ids are required query parameters' });
  }


  paymentRepository.deleteFromShopCart(cartIds, userId)
    .then((message) => {
      console.log('Deleted successfully:', message);
      res.status(200).json({ message: 'Cart items deleted successfully' });
    })
    .catch((error) => {
      console.error('Error deleting cart items:', error);
      res.status(500).json({ error: 'Internal server error' });
    });
};





exports.checkTheQuantityToPayment = (req, res) => {
  const userId = req.query.userId;

  paymentRepository.checkTheQuantityToPayment(userId)
    .then((data) => {
      console.log("Result from paymentRepository:", data);
      res.status(200).json(data);
    })
    .catch((error) => {
      console.error("Error in checkTheQuantityToPayment:", error);
      res.status(500).json({ message: 'Failed to process request' });
    });
};
