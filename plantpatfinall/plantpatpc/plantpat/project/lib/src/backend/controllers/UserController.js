const UserRepository = require('../data/database/UserRepo');

const userRepository = new UserRepository();


exports.loginUser = (req, res) => {
  userRepository.loginUser(req, res); 
};

exports.Editprofile = (req, res) => {
  
  const { id, firstName, lastName, email, address, phoneNumber} = req.body;
  userRepository
    .Editprofile(id, firstName, lastName, email, address, phoneNumber )
    .then((message) => {
      res.status(200).json({ message }); 
    })
    .catch((error) => {
      res.status(500).json({ error }); 
    });
};






exports.totalcustomer = (req, res) => {
  userRepository.totalcustomer()
    .then(totalCustomers => {
      res.status(200).json({ total_customers: totalCustomers });
    })
    .catch(err => {
      console.error('Error calculating total customers:', err);
      res.status(500).json({ error: 'Internal server error' });
    });
};



exports.savelocation = (req, res) => {
  const { userid, location, first_name, last_name, phone_number, city, street_address } = req.body;

  userRepository
    .savelocation(userid, location, first_name, last_name, phone_number, city, street_address)
    .then((message) => {
      res.status(200).json({ message }); 
    })
    .catch((error) => {
      res.status(500).json({ error });
    });
};

exports.location = (req, res) => {
  const { userid } = req.query; 


  userRepository.getLatestLocation(userid)
    .then((result) => {
      res.status(200).json(result); 
    })
    .catch((error) => {
      res.status(500).json({ error: 'Failed to retrieve location' }); 
    });
};




exports.oldpassword = async (req, res) => {
  const { email, oldPassword } = req.body;

  try {
 
    if (!email || !oldPassword) {
      return res.status(400).json({ message: 'Email and old password are required.' });
    }

   
    const isOldPasswordValid = await userRepository.oldpassword(email, oldPassword);

    if (isOldPasswordValid) {
  
      return res.status(200).json({ message: 'Old password is correct.' });
    } else {
     
      return res.status(401).json({ message: 'Old password is incorrect.' });
    }
  } catch (error) {
   
    console.error('Error in oldpassword controller:', error);
    return res.status(500).json({ message: 'Internal server error.' });
  }
};





exports.getuserbyemail = (req, res) => {
  const email = req.query.email; 
  console.log('Requested email:', email); 
  
  userRepository.getuserbyemail(email)
    .then(results => {
      res.json(results); 
    })
    .catch(error => {
      res.status(500).json({ error: 'An error occurred while fetching user data.' });
    });
};


exports.UpdatePass = (req, res) => {
  userRepository
    .updatePass(req, res)
    .then((message) => {
      console.log(message);
      res.status(201).json({ message }); 
    })
    .catch((error) => {
      res.status(400).json({ message: error }); 
    });
  };
  exports.deleteAccount = (req, res) => {
    const { userId } = req.query; 
    console.log('deleteAccount controller method invoked with userId:', userId);
    userRepository.deleteAccount(userId)
      .then((result) => {
        console.log(result);
        res.status(200).send(result);
      })
      .catch((error) => {
        console.error('Error:', error);
        res.status(500).send(error);
      });
  };



  exports.Namebyid = (req, res) => {
    const { userId } = req.query;
  
    userRepository.Namebyid(userId)
      .then((result) => {
        console.log(result);
        res.status(200).send(result);
      })
      .catch((error) => {
        console.error('Error:', error);
        res.status(500).send({ error: 'Internal Server Error' });
      });
  };





  exports.userName = (req, res) => {
    const { email } = req.query;
    console.log({email});
  
    userRepository.userName(email)
        .then((result) => {
            console.log({result});
        
            res.status(200).json(result);
        })
        .catch((error) => {
            console.error({error});
            res.status(500).json({ message: 'Internal server error' });
        });
  };


  


  exports.AllUserName = (req, res) => {
    userRepository
      .AllUserName(req, res)
      .then((message) => {
        res.status(201).json({ message }); 
      })
      .catch((error) => {
        res.status(400).json({ message: error }); 
      });
  };
  
  exports.addProfileImage = async (req, res) => {
    try {
      const message = await userRepository.addProfileImage(req, res);
      res.status(201).json({ message });
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  };
  
    

  
    
  exports.getProfileImage = (req, res) => {
    const { userId } = req.query;
    
    
    userRepository.getProfileImage(userId)
        .then((result) => {
            console.log({result});
    
            res.status(200).json(result);
        })
        .catch((error) => {
            console.error({error});
            res.status(500).json({ message: 'Internal server error' });
        });
    };

    exports.getProfileImagebyname = (req, res) => {
      const { name } = req.query;
     
      const [first_name, last_name] = name.split(' ');
    
      userRepository.getProfileImagebyname(first_name, last_name)
        .then((result) => {
          console.log({ result });
          res.status(200).json(result);
        })
        .catch((error) => {
          console.error({ error });
          res.status(500).json({ message: 'Internal server error', error });
        });
    };

    

    exports.logoutUser = (req, res) => {
      console.log("hello from controller");
      userRepository.logoutUser(req, res);
    };
    exports.AllUserName = (req, res) => {
      userRepository
        .AllUserName() 
        .then((results) => {
          res.status(200).json({ message: results }); 
        })
        .catch((error) => {
          res.status(500).json({ message: error }); 
        });
    };

    exports.check = (req, res) => {
      userRepository.check(req, res);
    };


    exports.userInteraction = (req, res) => {
      userRepository
        .userInteraction(req, res)
        .then((message) => {
          res.status(200).json({ message }); 
        })
        .catch((error) => {
          res.status(500).json({ error });
        });
    };


    
    
    exports.updateadminofuser = (req, res) => {
    
    
      userRepository.updateadminofuser(req, res);
    
    };


    

exports.adduserfromadmin = (req, res) => {
  userRepository
    .adduserfromadmin(req, res)
    .then((message) => {
      res.status(201).json({ message }); 
    })
    .catch((error) => {
      res.status(400).json({ message: error });
    });
};
    
  
  

    
    