

const express = require('express');
const { authenticateAdmin } = require('../middlewares/authenticateAdmin');
const plantController = require('../controllers/plantController.js');
const router = express.Router();
const multer = require('multer');
const path = require('path');

const imageStorage = multer.diskStorage({
  // Destination to store image     
  destination: 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads', 
    filename: (req, file, cb) => {
        cb(null, file.fieldname  +'_'+Date.now()
           + path.extname(file.originalname))
          // file.fieldname is name of the field (image)
          // path.extname get the uploaded file extension
  }
});

const imageUpload = multer({
  storage: imageStorage,
  limits: {
    fileSize: 1000000 // 1000000 Bytes = 1 MB
  },
  fileFilter(req, file, cb) {
    if (!file.originalname.match(/\.(png|jpg)$/)) { 
       // upload only png and jpg format
       return cb(new Error('Please upload a Image'))
     }
   cb(undefined, true)
}
})




//router.post('/AddSection' ,imageUpload.array('image',4 ),plantController.addSection);
 //router.post('/AddSection',plantController.addSection);


 router.post('/AddPlant', imageUpload.single('image'), plantController.addPlant);
 router.post('/AddSection', imageUpload.single('image'), plantController.AddSection);



 router.put('/updateplant',plantController.updateplant);//????????????

 router.get('/Sections', plantController.getSections);
 router.get('/plants' , plantController.getPlants);
 router.put('/updateplantnamebyid', plantController.updatePlantNameById);
 router.put('/updateplantpricebyid', plantController.updatePlantPriceById);

router.put('/updateplantquantitybyid', plantController.updatePlantQuantityById);




router.put('/addplantImage', imageUpload.single('image'), plantController.addplantImage);






 
 router.get('/Sectionname', plantController.getSectionName);


 router.get('/Sectionidbyname', plantController.Sectionidbyname);

 router.get('/allSectionname', plantController.getallSectionName);



 router.get('/plant', plantController.getPlantbysectionid);
 router.get('/plantbyid', plantController.getPlantbyid);
 router.get('/plantnamebyid', plantController.plantnamebyid);


 router.get('/price', plantController.getprice);

 router.get('/plantThisMonth', plantController.plantThisMonth);
 router.get('/popularity', plantController.popularity);

 router.get('/retriveplantHomeRecomendedSystem', plantController.retriveplantHomeRecomendedSystem);
 router.get('/retriveWordOfsearch', plantController.retriveWordOfsearch);
 router.get('/retriveProductOfsearch', plantController.retriveProductOfsearch);

 router.get('/plantImage', plantController.getplantimage);


 

 router.put('/incrementshopcart', plantController.incrementshopcart);

 router.put('/decrementshopcart', plantController.decrementshopcart);

 router.get('/getplantimage', plantController.getPlantImage);









router.put('/updateSection',authenticateAdmin ,plantController.updateSection);

router.put('/updatePlant',authenticateAdmin ,plantController.updatePlant);


router.delete('/deleteSection', plantController.deleteSection);

router.get('/isFavorite', plantController.getFavoriteStatus);

router.delete('/deletePlant', plantController.deletePlant);


router.post('/addToShopCart', plantController.addToShopCart);


router.get('/getCartItem', plantController.getToShopCart);
router.delete('/deleteCartItem', plantController.deleteFromShopCart);
router.put('/updateItemOnShopCart', plantController.updateItemOnShopCart);




router.post('/addToWishList', plantController.addToWishList);
router.get('/retriveFromWishList', plantController.retriveFromWishList);
router.delete('/deleteFromWishList', plantController.deleteFromWishList);

router.get('/findSimilar', plantController.findSimilar);


router.get('/totalproduct', plantController.totalnumberproductforstatistics);
router.get('/totalproductsold', plantController.totalnumbersoldproduct);



router.get('/paymentsPerPlant', plantController.paymentsPerPlant);

router.get('/paymentsPerSection', plantController.paymentsPerSection);




router.get('/totalrevenue', plantController.totalRevenue);
router.get('/totalorder', plantController.totalorder);
router.get('/BestSelling', plantController.BestSelling);
router.get('/RecetOrders', plantController.RecetOrders);



router.get('/ProductNewCollectionForNotification', plantController.ProductNewCollectionForNotification);
router.get('/checkQuantityForNotification', plantController.checkQuantityForNotification);
router.post('/addRatingProduct', plantController.addRatingProduct);








//router.post('/AddPlant' ,authenticateAdmin,imageUpload.array('image',4 ),plantController.addPlant);
module.exports = router;