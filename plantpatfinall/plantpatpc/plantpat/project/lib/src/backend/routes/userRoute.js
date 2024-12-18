const express = require('express');
const session = require('express-session');
const userController = require('../controllers/UserController.js');
const { authenticateAdmin } = require('../middlewares/authenticateAdmin.js');
const authController = require('../controllers/authController');
const multer = require('multer');
const path = require('path');
// yoyo
//const multer = require('multer');
//const path = require('path');
// yoyo


//



//

const router = express.Router();

// Routes for user registration and authentication
router.post('/login', userController.loginUser);
router.get('/logout', userController.logoutUser);//comment becous of session

router.post('/signup', authController.signup);
 router.post('/editprofile', userController.Editprofile);
 router.put('/UpdatePass', userController.UpdatePass);



 router.post('/oldpassword', userController.oldpassword); 



 router.get('/check-session', userController.check);//comment becous of session

 router.delete('/delete', userController.deleteAccount);

router.put('/Interaction', userController.userInteraction);

// //new  
 router.get('/userName', userController.userName);


 router.get('/Namebyid', userController.Namebyid);





 router.get('/totalcustomer', userController.totalcustomer);


 //router.put('/UpdatePass', userController.UpdatePass);
 router.get('/AllUserName',userController.AllUserName);//comment becouse session
 router.put('/updateadmin', userController.updateadminofuser);//comment becouse session
 router.get('/getProfileImage', userController.getProfileImage);

 router.get('/getProfileImagebyname', userController.getProfileImagebyname);


 router.get('/getuserbyemail', userController.getuserbyemail);
 //router.get('/deliveryEmployee', userController.deliveryEmployee);




 router.post('/adduseradmin', userController.adduserfromadmin);


 router.post('/savelocation', userController.savelocation);
 router.get('/location', userController.location);






 const imageStorage = multer.diskStorage({
  // Destination to store image     
  destination: 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads', 
  filename: (req, file, cb) => {
    cb(null, file.fieldname + '_' + Date.now() + path.extname(file.originalname));
  }
});

const imageUpload = multer({
  storage: imageStorage,
  limits: {
    fileSize: 1000000 // 1 MB
  },
  fileFilter(req, file, cb) {
    if (!file.originalname.match(/\.(png|jpg)$/)) { 
      return cb(new Error('Please upload an image (png or jpg)'));
    }
    cb(undefined, true);
  }
});

// Use .single if you're uploading only one image
router.put('/addProfileImage', imageUpload.single('image'), userController.addProfileImage);





module.exports = router;