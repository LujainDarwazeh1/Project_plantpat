const mysql = require('mysql2');
const bcrypt = require('bcrypt');
const path = require('path');
const fs = require('fs');

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '123456',
  database: 'plantpat',
});

class UserRepository {




    // for middlewares
    getUserType(userId) {
      return new Promise((resolve, reject) => {
        db.query(
          'SELECT user_type FROM user WHERE user_id = ?',
          [userId],
          (error, results) => {
            if (error) {
              reject('Error fetching user type from the database.');
            } else {
              if (results.length > 0) {
                resolve(results[0].user_type);
              } else {
                reject('User not found');
              }
            }
          }
        );
      });
    }

    signupUser(req, res) {
      const { email, password, first_name, last_name, address, phone_number, user_type } = req.body;
  
     
      bcrypt.hash(password, 10, (err, hash) => {
          if (err) {
              console.error('Error hashing password:', err);
              return res.status(500).json({ message: 'Internal server error' });
          }
  
          const query = `
              INSERT INTO user (first_name, last_name, email, password, address, phone_number, user_type)
              VALUES (?, ?, ?, ?, ?, ?, ?)
          `;
  
          db.query(query, [first_name, last_name, email, hash, address, phone_number, user_type], (err, results) => {
              if (err) {
                  if (err.code === 'ER_DUP_ENTRY') {
                      console.error('Email already in use:', email);
                      return res.status(401).json({ message: 'Email already in use.' });
                  } else {
                      console.error('Error inserting user into database:', err);
                      return res.status(500).json({ message: 'Internal server error' });
                  }
              }
  
              console.log('User created successfully:', results);
              return res.status(200).json({ message: 'User created successfully.' });
          });
      });
  }


  updatePass(req, res) {
    const { email, newPassword } = req.body;
    console.log(`Updating password for email: ${email} with new password: ${newPassword}`);

  
    console.log(email, newPassword);
    return new Promise((resolve, reject) => {
      console.log('aaaaaaaaaa');
      bcrypt.hash(newPassword, 10, (hashError, hashedPassword) => {
        if (hashError) {
          console.error('Error hashing the password:', hashError);
          return res.status(500).json({
            status: 'error',
            message: 'Error hashing the password',
          });
        }

        const newPass = hashedPassword;
        console.log(newPass);
        db.query(
          'UPDATE user SET password = ? WHERE email = ?',
          [newPass, email],
          (error, results) => {
            if (error) {
              reject('Failed to update password');
            } else {
              if (results.affectedRows === 0) {
                reject('User not found');
              } else {
                resolve(`Password updated successfully for the email: ${email}`);
              }
            }
          }
        );
      });
    });
  }



loginUser(req, res) {//my loginnnnnnnn
  if (req.session.userId) {
    return res.status(208).json({ message: 'User is already logged in.' }); 
  }

  const { email, password } = req.body;

db.query(
  'SELECT email,password, first_name, last_name , address, phone_number, user_id , birthday, user_type FROM user WHERE email = ? ',
  [email],
  (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ message: 'Internal server error' });
    }

    if (results.length === 0) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    const user = results[0];
    bcrypt.compare(
      password,
      user.password,
      (compareError, passwordMatch) => {
        if (compareError) {
          return res
            .status(500)
            .json({ message: 'Internal server error.' });
        }
        if (!passwordMatch) {
          return res.status(401).json({ message: 'Invalid data.' });
        }

        console.log(`First Name: ${user.first_name}, Last Name: ${user.last_name}, Address: ${user.address}, Phone Number: ${user.phone_number}, User Type: ${user.user_type}`);
        
        const userData = {
          email: user.email,
          first_name: user.first_name,
          last_name: user.last_name,
          address: user.address,
          phone_number: user.phone_number,
          user_id: user.user_id,
          birthday: user.birthday,
          user_type: user.user_type,  // admin 

      };
     req.session.userId = user.user_id; 
        return res.json({ message: 'Login successful.', user: userData });
        
       
      },
    );
  },
);
    
  
}


//newlogin
// loginUser(req, res) {
//   const { email, password } = req.body;

//   db.query(
//     'SELECT email, password, first_name, last_name, address, phone_number, user_id, birthday, user_type FROM user WHERE email = ?',
//     [email],
//     (err, results) => {
//       if (err) {
//         console.error(err);
//         return res.status(500).json({ message: 'Internal server error' });
//       }

//       if (results.length === 0) {
//         return res.status(401).json({ message: 'Invalid email or password' });
//       }

//       const user = results[0];
//       bcrypt.compare(password, user.password, (compareError, passwordMatch) => {
//         if (compareError) {
//           return res.status(500).json({ message: 'Internal server error.' });
//         }
//         if (!passwordMatch) {
//           return res.status(401).json({ message: 'Invalid email or password.' });
//         }

//         req.session.userId = user.user_id;
//         return res.json({ message: 'Login successful.', user: { ...user, password: undefined } });
//       });
//     }
//   );
// }




Editprofile = (id, firstName, lastName, email, address, phoneNumber) => {

  console.log(`Updating profile for user ID: ${id}`);
  console.log(`New profile data:`, {
    firstName,
    lastName,
    email,
    address,
    phoneNumber
  });
  return new Promise((resolve, reject) => {
  
    db.query(
      'UPDATE user SET first_name = ?, last_name = ?, email = ?, address = ?, phone_number = ? WHERE user_id = ?',
      [firstName, lastName, email, address, phoneNumber, id],
      (error, results) => {
        if (error) {
          console.error('Error updating profile:', error);
          return reject('Failed to update profile');
        }
        if (results.affectedRows === 0) {
          return reject('User not found or no changes applied');
        }
        return resolve('Profile updated successfully');
      }
    );
  });
};





savelocation = (userid, location, first_name, last_name, phone_number, city, street_address) => {
  return new Promise((resolve, reject) => {
    db.query(
      'INSERT INTO location (userid, location, first_name, last_name, phone_number, city, street_address) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [userid, location, first_name, last_name, phone_number, city, street_address],
      (error, results) => {
        if (error) {
          console.error('Error saving location:', error);
          return reject('Failed to save location');
        }
        return resolve('Location saved successfully');
      }
    );
  });
};


getLatestLocation = (userid) => {
  return new Promise((resolve, reject) => {
    const query = `
      SELECT * 
      FROM location 
      WHERE userid = ? 
      ORDER BY created_at DESC 
      LIMIT 1
    `;
    
    db.query(query, [userid], (error, results) => {
      if (error) {
        console.error('Error retrieving latest location:', error);
        return reject(error);
      }
      if (results.length === 0) {
        return resolve({ message: 'No location found for this user' });
      }
      return resolve(results[0]); 
    });
  });
};


oldpassword(email, oldPassword) {
  return new Promise((resolve, reject) => {
    console.log(email);
    console.log(oldPassword);
   
    db.query(
      'SELECT password FROM user WHERE email = ?',
      [email],
      (error, results) => {
        if (error) {
          console.error('Error checking old password:', error);
          return reject('Internal server error.');
        }

       
        if (results.length === 0) {
          console.log(results.length);
          console.log('\n \n ');
          return reject('User not found.');
        }

        const storedPassword = results[0].password;

        
        bcrypt.compare(
          oldPassword,
          storedPassword,
          (compareError, passwordMatch) => {
            if (compareError) {
              console.error('Error comparing passwords:', compareError);
              return reject('Internal server error.');
            }

            if (passwordMatch) {
          
              console.log('Old password matches the stored password');
              resolve(true);
            } else {
              console.log('New password not matches the stored password');
              
              resolve(false);
            }
          }
        );
      }
    );
  });
}

userName(email) {
  return new Promise((resolve, reject) => {
   
    db.query('SELECT first_name, last_name , user_id FROM user WHERE email = ?', [email], (error, results) => {
      if (error) {
        console.error(error);
        reject('User not found');
      } else {
      
        resolve(results);
      }
    });
  });
}




addProfileImage = (req, res) => {
  const { email, userId } = req.body;

  console.log(email, userId);

  return new Promise((resolve, reject) => {
    const firstimagePath = req.file.path; 

    fs.readFile(firstimagePath, (err, datafirstimage) => {
      if (err) {
        return reject('Error reading file');
      }
      db.query(
        'UPDATE user SET profile_image = ? WHERE user_id = ?',
        [datafirstimage, userId],
        (error2, results2) => {
          if (error2) {
            return reject('Failed to update user profile image');
          }
          resolve('Profile image updated successfully');
        }
      );
    });
  });
};





getProfileImage(userId) {


  return new Promise((resolve, reject) => {


    db.query('SELECT * FROM user WHERE user_id = ?', [userId], (error, results) => {
      if (error || results.length==0) {
        console.error(error);
        reject(' not found');
      } 
      else{
        resolve({results});}
  });
  });
}



getProfileImagebyname(first_name, last_name) {
  return new Promise((resolve, reject) => {
    const query = 'SELECT * FROM user WHERE first_name = ? AND last_name = ?';
    db.query(query, [first_name, last_name], (error, results) => {
      if (error) {
        console.error(error);
        reject('Error executing query');
      } else if (results.length === 0) {
        resolve({ message: 'User not found' });
      } else {
        resolve(results);
      }
    });
  });
}




logoutUser(req, res) {
  console.log("hello from repo");
  const { userId } = req.session;
  console.log(`User ID from session: ${userId}`);

  if (!userId) {
    console.log("No user ID found in session.");
    return res.status(400).json({ message: 'No user ID found in session.' });
  }

  
  db.query(
    'SELECT * FROM user WHERE user_id = ? ',
    [userId],
    (searchError, results) => {
      if (searchError) {
        res.status(500).json({ message: 'Error logging out.' });
      } else if (results.length === 0) {
        res.status(500).json({ message: 'Error logging out.' });
      } else {
        
        req.session.destroy((err) => {
          if (err) {
            console.log(err);
            res.status(500).json({ message: 'Error logging out.'});
            
          } else {
            res.json({ message: 'Logged out successfully.' });
          }
        });
      }
    },
  );
}



//new logout

// logoutUser(req, res) {
//   const { userId } = req.session;

//   if (!userId) {
//     return res.status(400).json({ message: 'No user ID found in session.' });
//   }

//   req.session.destroy((err) => {
//     if (err) {
//       return res.status(500).json({ message: 'Error logging out.' });
//     } else {
//       return res.json({ message: 'Logged out successfully.' });
//     }
//   });
// }


AllUserName = () => {
  return new Promise((resolve, reject) => {
    db.query(
      'SELECT user_id, first_name, last_name, email, password, address, phone_number, user_type FROM user',
      (error, results) => {
        if (error) {
          return reject('Internal server error.');
        }
        resolve(results); 
      }
    );
  });
};




check(req, res) {
  if (req.session.userId) {
    this.getUserType(req.session.userId)
      .then(userType => {
        res.json({ loggedIn: true, userType });
      })
      .catch(error => {
        res.status(500).json({ loggedIn: false, error });
      });
  } else {
    res.json({ loggedIn: false });
  }
}

userInteraction(req, res) {
  let { plantId, userId, view, addToCart, purchased,wishlist } = req.body;
  
  return new Promise((resolve, reject) => {
    db.query(
      'SELECT * FROM user_interaction WHERE plant_id = ? AND user_id = ?', [plantId, userId],
      (error, results) => {
        if (error) {
          console.log(error);
          return reject('Failed to select user interaction');
        } else {
          if (results.length == 0) {
            db.query(
              'INSERT INTO user_interaction (plant_id, user_id, viewed, added_to_cart, purchased,wishlist) VALUES (?, ?, ?, ?, ?,?)',
              [plantId, userId, view, addToCart, purchased,wishlist],
              (error1, results1) => {
                if (error1) {
                  console.log(error1);
                  return reject('Failed to insert user interaction');
                } else {
              
                  db.query(
                    'SELECT * FROM user_interaction WHERE user_id = ? ORDER BY created_at ASC',
                    [userId],
                    (error2, results2) => {
                      if (error2) {
                        console.log(error2);
                        return reject('Failed to fetch user interactions');
                      } else if (results2.length > 5) {
                        const oldestInteractionId = results2[0].interaction_id;
                        db.query(
                          'DELETE FROM user_interaction WHERE interaction_id = ?',
                          [oldestInteractionId],
                          (error3, results3) => {
                            if (error3) {
                              console.log(error3);
                              return reject('Failed to delete oldest user interaction');
                            } else {
                              return resolve('Stored user interaction successfully and maintained the limit of 5 interactions');
                            }
                          }
                        );
                      } else {
                        return resolve('Stored user interaction successfully');
                      }
                    }
                  );
                }
              }
            );
          } else {//////////////////////////
           
            let viewProd = results[0].viewed;
            let addedToCart = results[0].added_to_cart;
            let purchasedProd = results[0].purchased;
            let wishlistProd=results[0].wishlist;

            if (view == 0 && viewProd == 1) {
              view = 1;
            }
            if (addToCart == 0 && addedToCart == 1) {
              addToCart = 1;
            }
            if (purchased == 0 && purchasedProd == 1) {
              purchased = 1;
            }
            if (wishlist == 0 && wishlistProd == 1) {
              wishlist = 1;
            }

            
console.log('hhhhhhhellllllo');
            db.query(
              'UPDATE user_interaction SET viewed = ?, added_to_cart = ?, purchased = ?,wishlist = ? WHERE user_id = ? AND plant_id = ?',
              [view, addToCart, purchased,wishlist, userId, plantId],
              (error2, results2) => {
                if (error2) {
                  console.log(error2);
                  return reject('Failed to update user interaction');
                } else {
                  return resolve('Updated user interaction successfully');
                }
              }
            );
          }
        }
      }
    );
  });
}






AllUserName(req, res) {
  return new Promise((resolve, reject) => {
    
    db.query(
      'SELECT first_name, last_name,email, user_type , user_id  FROM user ',
   
      (error, results) => {
        if (error) {
          return reject('Internal server error.');
        }

        return resolve(results);

      
        
     
      },
    );
  });


}




Namebyid = (userId) => {
  return new Promise((resolve, reject) => {
    const query = 'SELECT first_name, last_name FROM user WHERE user_id = ?';
    db.query(query, [userId], (error, results) => {
      if (error) {
        return reject(error);
      }
      resolve(results);
    });
  });
};
updateadminofuser(req, res) {
  const { first_name, last_name, email, user_type } = req.body;

  db.query(
    'UPDATE user SET first_name = ?, last_name = ?, user_type = ? WHERE email = ?',
    [first_name, last_name, user_type, email],
    (err, result) => {
      if (err) {
        res.status(500).send({ error: 'Failed to update user' });
      } else {
        res.status(201).send();
      }
    }
  );

}

adduserfromadmin = (req, res) => {
  const { first_name, last_name, email, user_type, password, phone_number, address } = req.body;

  return new Promise((resolve, reject) => {
    db.query(
      'SELECT * FROM User WHERE email = ?',
      [email],
      (error, results) => {
        if (error) {
          return reject('Internal server error.');
        }

        if (results.length > 0) {
          return reject('Email already in use.');
        }

        bcrypt.hash(password, 10, (hashError, hashedPassword) => {
          if (hashError) {
            return reject('User registration failed.');
          }

          db.query(
            'INSERT INTO user (first_name, last_name, email, password, address, phone_number, user_type) VALUES (?, ?, ?, ?, ?, ?, ?)',
            [first_name, last_name, email, hashedPassword, address, phone_number, user_type],
            (insertError) => {
              if (insertError) {
                return reject('User registration failed. Please try again.');
              }

              return resolve('User registered successfully.');
            }
          );
        });
      }
    );
  });
};




totalcustomer() {
  return new Promise((resolve, reject) => {
    const query = `
      SELECT COUNT(*) AS total_customers FROM user WHERE user_type = 'Buyer'
    `;

    db.query(query, (err, result) => {
      if (err) {
        return reject(err);
      }

    
      const totalCustomers = result[0].total_customers;
      resolve(totalCustomers);
    });
  });
}

getuserbyemail = (email) => {
  const query = `
    SELECT user_id, first_name, last_name, email, address, birthday, phone_number, user_type
    FROM user
    WHERE email = ?
  `;
  
  return new Promise((resolve, reject) => {
    db.query(query, [email], (error, results) => {
      if (error) {
        reject(error); 
      } else {
        resolve(results); 
      }
    });
  });
};





deleteAccount(userId) {
  console.log('deleteAccount function called with userId:', userId);

  return new Promise((resolve, reject) => {
    db.query('DELETE FROM pay WHERE user_id = ?', [userId], (error, results) => {
      if (error) {
        console.error('Error deleting records from pay:', error);
        return reject('Failed to delete account');
      }

      db.query('DELETE FROM productrating WHERE user_id = ?', [userId], (error, results) => {
        if (error) {
          console.error('Error deleting records from productrating:', error);
          return reject('Failed to delete account');
        }

        db.query('DELETE FROM shopping_cart WHERE user_id = ?', [userId], (error, results) => {
          if (error) {
            console.error('Error deleting records from shopping_cart:', error);
            return reject('Failed to delete account');
          }

          db.query('DELETE FROM user_interaction WHERE user_id = ?', [userId], (error, results) => {
            if (error) {
              console.error('Error deleting records from user_interaction:', error);
              return reject('Failed to delete account');
            }

            db.query('DELETE FROM wishlist WHERE user_id = ?', [userId], (error, results) => {
              if (error) {
                console.error('Error deleting records from wishlist:', error);
                return reject('Failed to delete account');
              }

              db.query('DELETE FROM user WHERE user_id = ?', [userId], (error, results) => {
                if (error) {
                  console.error('Error deleting user record:', error);
                  return reject('Failed to delete account');
                }

                if (results.affectedRows === 0) {
                  return reject('User not found');
                }

                console.log('Account deleted successfully');
                resolve('Account deleted successfully');
              });
            });
          });
        });
      });
    });
  });
}
















}

module.exports = UserRepository;
