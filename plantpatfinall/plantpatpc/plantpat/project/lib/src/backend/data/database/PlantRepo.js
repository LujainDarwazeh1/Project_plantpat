
const mysql = require('mysql2');
const bcrypt = require('bcrypt');
const path = require('path');
const fs = require('fs');
const recommendations = require('../../../AI/collaborative-filtering');

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '123456',
  database: 'plantpat',
});

class PlantRepository {

  addPlant(req, res) {
    console.log("Received request to add plant");
    return new Promise((resolve, reject) => {
      const { name, description, size, height, price, quantity, sectionId } = req.body;
      const imagePath = req.file.path; 
  
     
      fs.readFile(imagePath, (err, imageData) => {
        if (err) {
          console.error("Error reading image file:", err);
          return reject({ message: 'Error reading image file' });
        }
        console.log("Image received:", req.file); 
  
        
        db.query(
          'SELECT sectionid FROM section WHERE sectionid = ?',
          [sectionId],
          (error, results) => {
            if (error) {
              console.error('Error checking sectionid:', error);
              return reject({ message: 'Internal server error' });
            } else if (results.length === 0) {
              return reject({ message: 'Section ID does not exist' });
            } else {
        
              db.query(
                'INSERT INTO plant (name, description, size, height, price, quantity, sectionid, image) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
                [name, description, size, height, price, quantity, sectionId, imageData],
                (error, results) => {
                  if (error) {
                    console.error('Error adding plant:', error);
                    return reject({ message: 'Failed to add plant' });
                  } else {
                    console.log('Plant added successfully with image');
                    resolve({ message: 'Plant added successfully' });
                  }
                }
              );
            }
          }
        );
      });
    });
  }

  AddSection = (req, res) => {
    console.log("Received request to add section");
  
 
    const { name, description } = req.body;
    const imagePath = req.file.path;
  
    return new Promise((resolve, reject) => {
 
      fs.readFile(imagePath, (err, imageData) => {
        if (err) {
          console.error("Error reading image file:", err);
          return reject(new Error('Error reading image file'));
        }
        console.log("Image received:", req.file);
  
       
        const query = 'INSERT INTO section (name, description, image) VALUES (?, ?, ?)';
        const values = [name, description, imageData];
  
        db.query(query, values, (error, results) => {
          if (error) {
            console.error('Error adding section:', error);
            return reject(new Error('Failed to add section'));
          }
  
          console.log('Section added successfully with image');
          resolve('Section added successfully'); 
        });
      });
    });
  };


  
  
  
   getSectionIdByName = (sectionname) => {
    console.log('Querying section ID for section name:', sectionname); 
  
    return new Promise((resolve, reject) => {
      db.query(
        'SELECT sectionid FROM section WHERE name = ?',
        [sectionname],
        (error, results) => {
          if (error) {
            console.error('Error retrieving section ID:', error); 
            reject(new Error('Internal Server Error'));
          } else if (results.length === 0) {
            console.log('No results found for section name:', sectionname); 
            reject(new Error('Section not found'));
          } else {
            console.log('Results found:', results); 
            resolve(results[0].sectionid);
          }
        }
      );
    });
  };
  
  
  
    addSection(req, res) {
      const { name, description } = req.body;
  
     
  
      return new Promise((resolve, reject) => {
        db.query(
          'INSERT INTO section (name, description) VALUES (?, ?)',
          [name, description],
          (error, results) => {
            if (error) {
              console.error('Error adding section:', error);
              reject(error);
            } else {
              resolve('Section added successfully');
            }
          }
        );
      });
    }



    deleteSection(sectionId){
      return new Promise((resolve, reject) => {
        db.query(
          'DELETE FROM section WHERE sectionid = ?',
          [sectionId],
          (error, results) => {
            if (error) {
              console.error('Error deleting section:', error);
              reject(error);
            } else if (results.affectedRows === 0) {
              reject(new Error('No section found with the provided id'));
            } else {
              resolve('Section deleted successfully');
            }
          }
        );
      });
    };
    

    deletePlant = (plantId) => {
      return new Promise((resolve, reject) => {
      
        db.beginTransaction((err) => {
          if (err) {
            return reject(err);
          }
    
    
          db.query(
            'DELETE FROM productrating WHERE plant_id = ?',
            [plantId],
            (error) => {
              if (error) {
                return db.rollback(() => reject(error));
              }
    
              
              db.query(
                'DELETE FROM shopping_cart WHERE plant_id = ?',
                [plantId],
                (error) => {
                  if (error) {
                    return db.rollback(() => reject(error));
                  }
    
                 
                  db.query(
                    'DELETE FROM user_interaction WHERE plant_id = ?',
                    [plantId],
                    (error) => {
                      if (error) {
                        return db.rollback(() => reject(error));
                      }
    
                      
                      db.query(
                        'DELETE FROM wishlist WHERE plant_id = ?',
                        [plantId],
                        (error) => {
                          if (error) {
                            return db.rollback(() => reject(error));
                          }
    
                          
                          db.query(
                            'DELETE FROM plant WHERE id = ?',
                            [plantId],
                            (error, results) => {
                              if (error) {
                                return db.rollback(() => reject(error));
                              }
    
                           
                              db.commit((err) => {
                                if (err) {
                                  return db.rollback(() => reject(err));
                                }
                                resolve('Plant deleted successfully');
                              });
                            }
                          );
                        }
                      );
                    }
                  );
                }
              );
            }
          );
        });
      });
    };
    
    
  







  updateSection(req, res) {
    const { sectionId, name, description } = req.body;
  
   
  
    return new Promise((resolve, reject) => {
      db.query(
        'UPDATE section SET name = ?, description = ? WHERE sectionid = ?',
        [name, description, sectionId],
        (error, results) => {
          if (error) {
            console.error('Error updating section:', error);
            reject({ message: 'Failed to update section' });
          } else {
            if (results.affectedRows === 0) {
              reject({ message: 'Section not found or no changes applied' });
            } else {
              resolve({ message: 'Section updated successfully' });
            }
          }
        }
      );
    });
  }

  
   updatePlant (req, res)  {
    const { plantId, name, description, size, height, price, sectionId, quantity } = req.body;
  
   
  
    return new Promise((resolve, reject) => {
      db.query(
        'UPDATE plant SET name = ?, description = ?, size = ?, height = ?, price = ?, sectionid = ?, quantity = ? WHERE id = ?',
        [name, description, size, height, price, sectionId, quantity, plantId],
        (error, results) => {
          if (error) {
            console.error('Error updating plant:', error);
            reject({ message: 'Failed to update plant' });
          } else {
            if (results.affectedRows === 0) {
              reject({ message: 'Plant not found or no changes applied' });
            } else {
              resolve({ message: 'Plant updated successfully' });
            }
          }
        }
      );
    });
  };


  getprice(id){
    return new Promise((resolve, reject) => {
        db.query('SELECT price FROM plant WHERE id = ?', [id], (error, results) => {
            if (error) {
                console.error(error);
                reject('Failed to fetch plant price');
            } else {
                if (results.length > 0) {
                    resolve(results[0]);
                } else {
                    reject('No plant found with the given ID');
                }
            }
        });
    });
};

  plantThisMonth (req, res)  {
    return new Promise((resolve, reject) => {
        const oneWeekAgo = new Date();
        oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);
        const formattedDate = oneWeekAgo.toISOString().slice(0, 19).replace('T', ' ');

        db.query(
            'SELECT * FROM plant WHERE created_at >= ?',
            [formattedDate],
            (error, results) => {
                if (error) {
                    reject('Failed to retrieve plants');
                } else {
                    resolve(results);
                }
            }
        );
    });
};



popularity(req, res) {


  return new Promise((resolve, reject) => {
    db.query(
      'SELECT * FROM plant ORDER BY average_rating DESC LIMIT 2',
      (err, results) => {
        if (err) {
          reject(err);
        } else {
          resolve(results);
        }
      }
    );
  });


}





retriveplantHomeRecomendedSystem(userId) {
  console.log(userId);
  return new Promise((resolve, reject) => {

    db.query(
      'SELECT p.sectionid, p.size, p.price FROM user_interaction ui JOIN plant p ON ui.plant_id = p.id WHERE ui.user_id = ? ORDER BY ui.created_at DESC LIMIT 5',
      [userId],
      (err, interactionResults) => {
        if (err) {
          console.error(err);
          return reject('Failed to fetch interactions');
        }

        if (interactionResults.length === 0) {
          return resolve('No interactions found');
        }


        const filters = interactionResults.map(row => `p.sectionid = ${row.sectionid} AND p.size = '${row.size}' AND p.price = ${row.price}`);
        const filterConditions = filters.join(' OR ');



         const query = `
           SELECT p.id, p.name, p.description, p.sectionid, p.size, p.price, s.name AS section_name
           FROM plant p
           JOIN section s ON p.sectionid = s.sectionid
           LEFT JOIN user_interaction ui ON p.id = ui.plant_id AND ui.user_id = ?
           WHERE (${filterConditions}) AND ui.plant_id IS NULL
         `;

//        const query = `
//  SELECT p.id, p.name, p.description, p.sectionid, p.size, p.price, s.name AS section_name
//  FROM plant p
//  JOIN section s ON p.sectionid = s.sectionid
//  LEFT JOIN user_interaction ui ON p.id = ui.plant_id AND ui.user_id = ?
//  WHERE (${filterConditions}) AND ui.plant_id IS NULL
//`;

        console.log("Executing query:", query);


        db.query(query, [userId], (err2, recommendedProducts) => {
          if (err2) {
            console.error(err2);
            return reject('Failed to fetch recommended plant details');
          }

          if (recommendedProducts.length === 0) {
            return resolve('No recommendations found');
          }


          const allProducts = recommendedProducts;
          const outputWithoutFiltering = recommendedProducts;
          console.log("helllllllllllo");

          console.log(outputWithoutFiltering);

          const userInteractedProductIds = interactionResults.map(p => p.plant_id);
          const userInteractions = allProducts.map(plant =>
            userInteractedProductIds.includes(plant.id) ? 1 : 0
          );


          const ratings = [
            userInteractions,
            ...new Array(4).fill(new Array(allProducts.length).fill(0))
          ];


          const userInteractedPrice = new Set(recommendedProducts.map(p => p.price));
          const similarPriceProducts = allProducts.filter(plant =>
            userInteractedPrice.has(plant.price)
          );

          const similarPriceProductIds = similarPriceProducts.map(p => p.id);


          const collabRecommendations = recommendations.cFilter(ratings, 0);
          console.log('Collaborative Filtering Recommendations:', collabRecommendations);

          const plantFeatures = allProducts.map(plant => ({
            sectionId: plant.sectionid,
            size: plant.size,
            price: plant.price,
            id: plant.id,
          }));


          const contentRecommendations = recommendations.contentBasedFiltering(plantFeatures, recommendedProducts);
          console.log('Content-Based Filtering Recommendations:', contentRecommendations);


          const filteredContentRecommendations = contentRecommendations.filter(rec =>
            similarPriceProductIds.includes(rec)
          );

          console.log('Filtered Content Recommendations:', filteredContentRecommendations);


          const hybridRecommendations = recommendations.combineRecommendations(collabRecommendations, filteredContentRecommendations);
          console.log('Hybrid Recommendations:', hybridRecommendations);

          if (hybridRecommendations.length === 0) {
            return resolve('No recommendations found');
          }

          const hybridPlaceholders = hybridRecommendations.map(() => '?').join(',');

          db.query(
            `SELECT p.id, p.name, p.description, p.size, p.height, p.price, p.sectionid, p.quantity, p.average_rating,p.created_at,p.image, s.name AS section_name
             FROM plant p
             JOIN section s ON p.sectionid = s.sectionid
             WHERE p.id IN (${hybridPlaceholders})`,
            hybridRecommendations,
            (err4, finalRecommendedProducts) => {
              if (err4) {
                console.error(err4);
                return reject('Failed to fetch final recommended plant details');
              }

              resolve(finalRecommendedProducts);
            }
          );
        });
      }
    );
  });
}










retriveWordOfsearch(name) {
  return new Promise((resolve, reject) => {
    const query = `
      SELECT p.name AS plant_name
      FROM plant p
      
      WHERE p.name LIKE CONCAT('%', ?, '%')
    `;
    console.log('Executing SQL query:', query);
    console.log('Parameters:', name, name);
    db.query(query, [name, name], (error, results) => {
      if (error) {
        console.error('Error executing query:', error);
        reject('Failed to Search');
      } else {
        console.log('Search results:', results);
        resolve(results);
      }
    });
  });
}



retriveProductOfsearch(name) {
  return new Promise((resolve, reject) => {
    const query = `
      SELECT plant.*
      FROM plant
      JOIN section ON plant.sectionid = section.sectionid
      WHERE LOWER(plant.name) = LOWER(?)
    `;

    console.log('Executing SQL query:', query);
    console.log('Name parameter:', name);

    db.query(query, [name], (error, results) => {
      if (error) {
        console.error('Error executing query:', error);
        reject('Failed to Search');
      } else if (results.length === 0) {
        reject('Not have thing to retrieve');
      } else {
        console.log('Search results:', results);
        resolve({ results });
      }
    });
  });
}





getplantimage(plantId) {
  return new Promise((resolve, reject) => {
  
    db.query('SELECT COUNT(*) AS count FROM plant WHERE id = ?', [plantId], (error, results) => {
      if (error) {
        console.error(error);
        reject('Failed to check if plant exists');
      } else {
        const count = results[0].count;
        if (count === 0) {
          reject('Plant not found'); 
        } else {
      
          db.query('SELECT image FROM plant WHERE id = ?', [plantId], (error, results) => {
            if (error) {
              console.error(error);
              reject('Failed to fetch plant image');
            } else {
              resolve(results);
            }
          });
        }
      }
    });
  });
}


getPlantById = (plantId, callback) => {
  db.query('SELECT image FROM plant WHERE id = ?', [plantId], (error, results) => {
    if (error) {
      console.error('Error querying the database:', error);
      callback(new Error('Database query error'), null);
      return;
    }
    
    if (results.length > 0) {
      callback(null, results[0]); 
    } else {
      callback(null, null); 
    }
  });
};

getFavoriteStatus = (plantId, userId, callback) => {
  if (!plantId || !userId) {
    return callback(new Error('Missing plantId or userId'));
  }

  const query = `
    SELECT COUNT(*) AS isFavorite
    FROM wishlist
    WHERE plant_id = ? AND user_id = ?
  `;

  db.execute(query, [plantId, userId], (err, results) => {
    if (err) {
      console.error('Error fetching favorite status:', err);
      return callback(new Error('Error fetching favorite status'));
    }
    const isFavorite = results[0].isFavorite > 0 ? 1 : 0;
    callback(null, isFavorite);
  });
};









  addToShopCart (req, res){
    console.log("hello from Repo");
  
    const { id, Number_Item, date, name } = req.body;
    const userId = id;
    const itemCount =Number_Item;
  
    console.log(name, itemCount, date);
  
    if (isNaN(userId) || isNaN(itemCount)) {
      console.error('Invalid id or Number_Item');
      return Promise.reject('Invalid id or Number_Item');
    }
  
    return new Promise((resolve, reject) => {
     
      db.query('SELECT user_id FROM user WHERE user_id = ?', [userId], (userError, userResult) => {
        if (userError) {
          console.error('Error querying user:', userError);
          return reject('Failed to store to cart');
        }
  
        if (userResult.length === 0) {
          console.error('User not found');
          return reject('User not found');
        }
  
     
        db.query('SELECT id FROM plant WHERE name = ?', [name], (error1, res1) => {
          if (error1) {
            console.error('Error querying plant:', error1);
            return reject('Failed to store to cart');
          }
  
          if (res1.length === 0) {
            console.error('Plant not found');
            return reject('Plant not found');
          }
  
          const plantId = res1[0].id;
          console.log('Plant ID:', plantId);
  
          const theDate = new Date(date);
  
        
          db.query('SELECT * FROM shopping_cart WHERE plant_id = ? AND user_id = ?', [plantId, userId], (error3, results3) => {
            if (error3) {
              console.error('Error querying shopping cart:', error3);
              return reject('Failed to store to cart');
            }
  
            if (results3.length > 0) {
              console.error('This item is already in the cart');
              return reject('This item is already in the cart');
            }
  
  
            db.query(
              'INSERT INTO shopping_cart (item, date_cart, user_id, plant_id) VALUES (?, ?, ?, ?)',
              [itemCount, theDate, userId, plantId],
              (error2, results2) => {
                if (error2) {
                  console.error('Error inserting into shopping cart:', error2);
                  return res.status(500).json({ error: 'Failed to store to cart' });
                }
            
                const cartId = results2.insertId;
                console.log('Stored to cart successfully with cart_id:', cartId);
            
                
                return res.status(200).json({ message: 'Stored to cart successfully', cart_id: cartId });
              }
            );
          });
        });
      });
    });
  };


  updatePlantNameById = (name, id) => {
    const query = 'UPDATE plant SET name = ? WHERE id = ?';
    const values = [name, id];


    return new Promise((resolve, reject) => {
        db.query(query, values, (error, results) => {
            if (error) {
                reject(error);
            } else {
                resolve(results);
            }
        });
    });
};



updatePlantPriceById(price, id) {
  return new Promise((resolve, reject) => {
    const query = 'UPDATE plant SET price = ? WHERE id = ?';
    db.query(query, [price, id], (error, result) => {
      if (error) {
        return reject(error);
      }
      resolve(result);
    });
  });
}



updatePlantQuantityById = (quantity, id) => {
  return new Promise((resolve, reject) => {
    const query = 'UPDATE plant SET quantity = ? WHERE id = ?';
    db.query(query, [quantity, id], (error, results) => {
      if (error) {
        return reject(error);
      }
      resolve(results);
    });
  });
};


 addplantImage = (req) => {
  const { plantid } = req.body;
  console.log('Plant ID:', plantid);

  return new Promise((resolve, reject) => {
    const imagePath = req.file.path;

    fs.readFile(imagePath, (err, data) => {
      if (err) {
        return reject('Error reading file');
      }
      db.query(
        'UPDATE plant SET image = ? WHERE id = ?',
        [data, plantid],
        (error) => {
          if (error) {
            return reject('Failed to update plant image');
          }
          resolve('Plant image updated successfully');
        }
      );
    });
  });
};

  
  

  
  getToShopCart(userId) {
    return new Promise((resolve, reject) => {
      console.log('User ID:', userId);
      db.query(`
        SELECT shopping_cart.*, plant.price AS plant_price
        FROM shopping_cart
        JOIN plant ON shopping_cart.plant_id = plant.id
        WHERE shopping_cart.user_id = ?
      `, [userId], (error, results) => {
        if (error) {
        
          return reject('Failed to retrieve from cart');
        } 
        
        if (results.length === 0) {

          return reject('Not have data in database to retrieve');
        }
        const theRes= results;
        const cartItems = results;
        const allProductData = [];
        let processedItems = 0;
  
        cartItems.forEach(cartRow => {
          const plantId = cartRow.plant_id;
     
  
          db.query('SELECT * FROM plant WHERE id = ?', [plantId], (error1, res1) => {
            processedItems++;
            
            if (error1) {
         
              return reject('Failed to retrieve product data');
            }
            
            if (res1.length > 0) {
              allProductData.push(...res1);
            }
  
            if (processedItems === cartItems.length) {
              if (allProductData.length === 0) {
                return reject('Not have data to retrieve');
              } else {
                console.log('Retrieved all products:', allProductData);
                resolve({ results, allProductData });
              }
            }
          });
        });
      });
    });
  }
  

  deleteFromShopCart(plantId, userId) {
    return new Promise((resolve, reject) => {
  
      db.query('SELECT cart_id FROM shopping_cart WHERE plant_id = ? AND user_id = ?', [plantId, userId], (error, results) => {
        if (error) {
          console.error('Error selecting cart_id:', error);
          reject('Failed to delete item');
          return;
        }
  
        
        const cartIds = results.map(row => row.cart_id);
        db.query('DELETE FROM payment_cart WHERE cart_id IN (?)', [cartIds], (error, paymentResults) => {
          if (error) {
            console.error('Error deleting from payment_cart:', error);
            reject('Failed to delete item');
            return;
          }
  
         
          db.query('DELETE FROM shopping_cart WHERE plant_id = ? AND user_id = ?', [plantId, userId], (error, deleteResults) => {
            if (error) {
              console.error('Error deleting item:', error);
              reject('Failed to delete item');
            } else if (deleteResults.affectedRows === 0) {
              console.log(`Deleted ${deleteResults.affectedRows} row(s) from shopping_cart`);
              reject('Item not found in the shopping cart');
            } else {
              console.log(`Deleted ${deleteResults.affectedRows} row(s) from shopping_cart`);
              resolve('Item deleted successfully');
            }
          });
        });
      });
    });
  }
  getPlantbysectionid = (sectionId, res) => {
    const query = `
      SELECT plant.*, section.name AS section_name
      FROM plant
      JOIN section ON plant.sectionid = section.sectionid
      WHERE plant.sectionid = ?;
    `;
  
    db.query(query, [sectionId], (error, results) => {
      if (error) {
        console.error('Error fetching plants by section ID:', error);
        res.status(500).json({ error: 'Database error' });
      } else {
        res.status(200).json(results);
      }
    });
  };

  updateItemOnShopCart(req, res) {
    const { item,plantId } = req.body;
    console.log(item);
    console.log(plantId);
    return new Promise((resolve, reject) => {
    
        db.query(
          'UPDATE shopping_cart SET item = ? WHERE plant_id = ?',
          [item,plantId],
          (error, results) => {
              if (error) {
                  reject('Failed to update item in shop cart ');
              } else {
                  resolve('item in shop cart updated successfully');
              }
          }
      );
  
  
  
    });
  }

  getSections(req, res) {
    db.query('SELECT * FROM section', (error, results) => {
      console.log({results});
      if (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
      } else {
        res.status(200).json(results);
      }
    });
  }




  getallSectionName(req, res) {
    db.query('SELECT sectionid, name FROM section', (error, results) => {
      console.log({ results });
      if (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
      } else {
        res.status(200).json(results);
      }
    });
  }
  
  

  getSectionName = async (id) => {
    return new Promise((resolve, reject) => {
      db.query('SELECT name FROM section WHERE sectionid = ?', [id], (error, results) => {
        if (error) {
          reject(error);
        } else {
          if (results.length > 0) {
            resolve(results[0].name);
          } else {
            resolve(null); 
          }
        }
      });
    });
  };
  


  getPlants(req, res) {




    db.query('SELECT id, name, description, size, height, price, sectionid, quantity, average_rating, created_at, image FROM plant ', (error, results) => {
      if (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
      } else {
        
        res.status(200).json(results);
      }
    });
  }



  updateplant(id, name, description, size, height, price, quantity, image) {
    return new Promise(function(resolve, reject) {
      var query = `UPDATE plant SET 
        name = ?, 
        description = ?, 
        size = ?, 
        height = ?, 
        price = ?, 
        quantity = ?, 
        image = ? 
      WHERE id = ?`;
  
      db.query(query, [name, description, size, height, price, quantity, image, id], function(error, results) {
        if (error) {
          return reject(error);
        }
  
        if (results.affectedRows > 0) {
          resolve('Plant updated successfully');
        } else {
          reject(new Error('Plant not found'));
        }
      });
    });
  }

  getPlantbyid = (plant_id) => {
    return new Promise((resolve, reject) => {
      const query = 'SELECT * FROM plant WHERE id = ?';
      db.query(query, [plant_id], (error, results) => {
        if (error) {
          return reject(error);
        }
        resolve(results); 
      });
    });
  };


  plantnamebyid = (plant_id) => {
    return new Promise((resolve, reject) => {
      const query = 'SELECT name FROM plant WHERE id = ?';
      db.query(query, [plant_id], (error, results) => {
        if (error) {
          return reject(error);
        }
        resolve(results); 
      });
    });
  };


  



  addToWishList(req, res) {
    const { userId, plantId } = req.body;
  
    return new Promise((resolve, reject) => {
      console.log(userId);
      console.log(plantId);
      
      db.query(
        'SELECT * FROM wishlist WHERE user_id = ? AND plant_id = ?',
        [userId, plantId],
        (error3, results3) => {
          if (error3) {
            console.error(error3);
            return reject('Failed to insert to wishlist');
          } else {
            if (results3.length === 0) {
              db.query(
                'INSERT INTO wishlist (user_id, plant_id) VALUES (?, ?)',
                [userId, plantId],
                (error3, results3) => {
                  if (error3) {
                    console.error(error3);
                    return reject('Failed to insert to wishlist');
                  } else {
                    return resolve('Inserted to wishlist successfully');
                  }
                }
              );
            } else {
              return reject('Product exists in wishlist, cannot add again');
            }
          }
        }
      );
    });
  }




  retriveFromWishList(userId) {
    return new Promise((resolve, reject) => {
      const planttDataWishList = [];
      db.query('SELECT * FROM wishlist WHERE user_id = ?', [userId], (error, results) => {
        if (error) {
          return reject('Internal server error.');
        } else {
          console.log('plant in wishlist results:', results);
          if (results.length === 0) {
           
            return resolve([]);
          }
  
          let processedCount = 0;
  
          results.forEach(plant => {
            const plantId = plant.plant_id; 
            db.query(
              'SELECT p.*, s.name as section_name FROM plant p JOIN section s ON p.sectionid = s.sectionid WHERE p.id = ?',
              [plantId],
              (error3, productData) => {
                if (error3) {
                  console.error(error3);
                  return reject('Failed to retrieve plant data');
                } else {
                  productData.forEach(entry => {
                    const found = planttDataWishList.find(item => JSON.stringify(item) === JSON.stringify(entry));
                    if (!found) {
                      planttDataWishList.push(entry);
                    }
                  });
                  processedCount++;
                  console.log('PlantDataWishList:', planttDataWishList);
  
                  if (processedCount === results.length) {
                    return resolve(planttDataWishList);
                  }
                }
              }
            );
          });
        }
      });
    });
  }





  deleteFromWishList(plantId, userId) {
    console.log(`Deleting plantId=${plantId}, userId=${userId} from wishlist`);
  
    return new Promise((resolve, reject) => {
      db.query('DELETE FROM wishlist WHERE plant_id = ? AND user_id = ?', [plantId, userId], (error2, res2) => {
        if (error2) {
          console.error('SQL Error:', error2);
          reject('Failed to delete data from wishlist');
        } else {
          console.log(`Deleted ${res2.affectedRows} row(s) from wishlist`);
          resolve('Success deleted');
        }
      });
    });
  }





 findSimilar(plantId) {
    console.log('Plant ID:', plantId);

    return new Promise((resolve, reject) => {
      
        db.query('SELECT size, sectionid FROM plant WHERE id = ?', [plantId], (error, results) => {
            if (error) {
                console.error('Error retrieving plant details:', error);
                return reject('Failed to retrieve plant details');
            }

            if (results.length === 0) {
                return reject('Plant not found');
            }

            const size = results[0].size;
            const sectionId = results[0].sectionid;

         
            db.query(
                'SELECT p.*, s.name as section_name FROM plant p JOIN section s ON p.sectionid = s.sectionid WHERE p.size = ? AND p.sectionid = ? AND p.id != ?',
                [size, sectionId, plantId],
                (error, results) => {
                    if (error) {
                        console.error('SQL Error:', error);
                        return reject('Failed to retrieve products');
                    }

                    console.log('Query results:', results);

                    
                    const productSimilar = [];
                    results.forEach(entry => {
                        const found = productSimilar.some(item => JSON.stringify(item) === JSON.stringify(entry));
                        if (!found) {
                            productSimilar.push(entry);
                        }
                    });

                    console.log('Filtered similar products:', productSimilar);
                    resolve(productSimilar); 
                }
            );
        });
    });
}




totalnumberproductforstatistics(req, res){

  db.query('SELECT COUNT(*) AS totalProducts FROM plant', (error, results) => {8
    if (error) {
      console.error(error);
      if (!res.headersSent) {
        res.status(500).json({ message: 'Internal server error' });
      }
    } else {
      if (!res.headersSent) {
        res.status(200).json(results[0]);
      }
    }
  });

}



totalNumberSoldProduct ()  {
  return new Promise((resolve, reject) => {
    const query = 'SELECT COUNT(DISTINCT cart_id) AS total_sold FROM payment_cart';

    db.query(query, (err, result) => {
      if (err) {
        return reject(err);
      }

      const totalSold = result[0].total_sold;
      resolve(totalSold);
    });
  });
};


paymentsPerPlant() {
  return new Promise((resolve, reject) => {
    const query = `
      SELECT p.id AS plant_id, IFNULL(SUM(CAST(sc.item AS UNSIGNED)), 0) AS payment_count
      FROM plant p
      LEFT JOIN shopping_cart sc ON p.id = sc.plant_id
      LEFT JOIN payment_cart pc ON sc.cart_id = pc.cart_id
      GROUP BY p.id`;

    db.query(query, (err, result) => {
      if (err) {
        return reject(err);
      }

     
      const plantsWithPayments = result.map(plant => ({
        plant_id: plant.plant_id,
        payment_count: plant.payment_count || 0  
      }));

      resolve(plantsWithPayments);
    });
  });
}



paymentsPerSection() {
  return new Promise((resolve, reject) => {
    const query = `
      SELECT 
        s.sectionid,
        s.name AS section_name,
        IFNULL(SUM(CAST(sc.item AS UNSIGNED) * p.price), 0) AS total_payments
      FROM 
        section s
        LEFT JOIN plant p ON s.sectionid = p.sectionid
        LEFT JOIN shopping_cart sc ON p.id = sc.plant_id
        LEFT JOIN payment_cart pc ON sc.cart_id = pc.cart_id
      GROUP BY 
        s.sectionid, s.name`;

    db.query(query, (err, result) => {
      if (err) {
        return reject(err);
      }

      
      const sectionsWithPayments = result.map(section => ({
        sectionid: section.sectionid,
        section_name: section.section_name,
        total_payments: section.total_payments || 0  
      }));

      resolve(sectionsWithPayments);
    });
  });
}





totalRevenue() {
  return new Promise((resolve, reject) => {
    const query = `
      SELECT SUM(total_amount) AS total_revenue
      FROM (
        SELECT user_id, payment_date, payment_method, delivery_option, MIN(amount) AS total_amount
        FROM pay
        GROUP BY user_id, payment_date, payment_method, delivery_option
      ) AS unique_totals
    `;

    db.query(query, (err, result) => {
      if (err) {
        return reject(err);
      }

      
      resolve(result[0].total_revenue || 0); 
    });
  });
}



getBestSellingPlants = () => {
  return new Promise((resolve, reject) => {
    const query = `
      SELECT p.name AS plant_name, 
             COUNT(*) * p.price AS total_revenue
      FROM pay AS pay
      JOIN plant AS p ON pay.plantid = p.id
      GROUP BY pay.plantid
      ORDER BY total_revenue DESC
      LIMIT 5
    `;

    db.query(query, (err, results) => {
      if (err) {
        return reject(err); 
      }
      resolve(results); 
    });
  });
};




getRecentOrders = () => {
  return new Promise((resolve, reject) => {
    const query = `
      SELECT
        ur.payment_date,
        ur.amount,
        ur.status,
        u.first_name
      FROM (
        SELECT
          user_id,
          payment_date,
          amount,
          status,
          payment_method,
          delivery_option,
          ROW_NUMBER() OVER (PARTITION BY user_id, payment_date, amount, payment_method, delivery_option, status ORDER BY payment_date DESC) AS rn
        FROM pay
        WHERE delivery_option = 'Our delivery system'
      ) AS ur
      JOIN user u ON ur.user_id = u.user_id
      WHERE ur.rn = 1
      ORDER BY ur.payment_date DESC
      LIMIT 5;
    `;

    db.query(query, (err, results) => {
      if (err) {
        return reject(err);
      }
      resolve(results);
    });
  });
};



totalOrder() {
  return new Promise((resolve, reject) => {
    const query = `
      SELECT COUNT(*) AS total_orders
      FROM (
        SELECT user_id, payment_date, payment_method, delivery_option, MIN(amount) AS total_amount
        FROM pay
        GROUP BY user_id, payment_date, payment_method, delivery_option
      ) AS unique_totals
    `;

    db.query(query, (err, result) => {
      if (err) {
        return reject(err);
      }

      
      resolve(result[0].total_orders || 0); 
    });
  });
}










ProductNewCollectionForNotification(userId) {
  console.log(userId);
  return new Promise((resolve, reject) => {
    
    db.query(
      'SELECT plant_id FROM user_interaction WHERE user_id = ? ORDER BY created_at DESC LIMIT 5',
      [userId],
      (err, results) => {
        if (err) {
          console.error(err);
          return reject('Failed to fetch interactions');
        }

        const plantIds = results.map(row => row.plant_id);
        console.log(plantIds);

        if (plantIds.length === 0) {
          return resolve('No interactions found');
        }

      
        const placeholders = plantIds.map(() => '?').join(',');
        db.query(
          `SELECT p.id, p.sectionid 
           FROM plant p 
           WHERE p.id IN (${placeholders})`,
          plantIds,
          (err2, plantResults) => {
            if (err2) {
              console.error(err2);
              return reject('Failed to fetch plant metadata');
            }

            
            const sectionIds = [...new Set(plantResults.map(p => p.sectionid))];
            const sectionPlaceholders = sectionIds.map(() => '?').join(',');

          
            db.query(
              `SELECT * FROM plant WHERE sectionid IN (${sectionPlaceholders}) AND created_at >= NOW() - INTERVAL 24 HOUR`,
              sectionIds,
              (err3, allPlants) => {
                if (err3) {
                  console.error(err3);
                  return reject('Failed to fetch related plants');
                }

                if (allPlants.length === 0) {
                  return reject('No new plants found');
                }

                console.log(allPlants);

              
                const uniquePlantIds = new Set();
                const uniquePlants = [];

                allPlants.forEach(plant => {
                  if (!uniquePlantIds.has(plant.id)) {
                    uniquePlantIds.add(plant.id);
                    uniquePlants.push(plant);
                  }
                });

                console.log(uniquePlants);

                resolve(uniquePlants);
              }
            );
          }
        );
      }
    );
  });
}




checkQuantityForNotification(userId) {
  return new Promise((resolve, reject) => {
  
    db.query('SELECT plant_id FROM shopping_cart WHERE user_id = ?', [userId], (error, results) => {
      if (error) {
        console.error(error);
        return reject('Error retrieving shopping cart items');
      }

      if (results.length === 0) {
        return reject('No products found in shopping cart');
      }

   
      const plantIds = results.map(row => row.plant_id);

      if (plantIds.length === 0) {
        return reject('No products found in shopping cart');
      }

     
      const placeholders = plantIds.map(() => '?').join(',');

      
      const query = `SELECT * FROM plant WHERE id IN (${placeholders}) AND quantity IN (1, 2)`;
      db.query(query, plantIds, (error, plantResults) => {
        if (error) {
          console.error(error);
          return reject('Error retrieving plant details');
        }

        if (plantResults.length === 0) {
          return reject('No plants with quantity 1 or 2 found');
        }

        // Remove duplicates
        const uniquePlantResults = [];
        const plantIdsSet = new Set();

        plantResults.forEach(plant => {
          if (!plantIdsSet.has(plant.id)) {
            uniquePlantResults.push(plant);
            plantIdsSet.add(plant.id);
          }
        });

        resolve(uniquePlantResults);
      });
    });
  });
}






// totalnumbersoldproduct(req, res){
//   db.query('SELECT COUNT(*) AS totalProductsSold FROM pay', (error, results) => {
//     if (error) {
//       console.error(error);
//       if (!res.headersSent) {
//         res.status(500).json({ message: 'Internal server error' });
//       }
//     } else {
//       if (!res.headersSent) {
//         res.status(200).json(results[0]); // Sending only the first result
//       }
//     }
//   });}

//     totalRevenue(req, res) {
//       // First, get the total revenue
//       db.query('SELECT SUM(amount) AS totalrevenue FROM pay', (error, totalResults) => {
//         if (error) {
//           console.error(error);
//           if (!res.headersSent) {
//             res.status(500).json({ message: 'Internal server error' });
//           }
//         } else {
//           const totalRevenue = totalResults[0].totalrevenue;
    
//           // Then, get the revenue for each product
//           db.query('SELECT idproduct, SUM(amount) AS productrevenue FROM pay GROUP BY idproduct', (error, productResults) => {
//             if (error) {
//               console.error(error);
//               if (!res.headersSent) {
//                 res.status(500).json({ message: 'Internal server error' });
//               }
//             } else {
//               // Calculate the admin profit for each product (10% of revenue)
//               const resultsWithAdminProfit = productResults.map(product => {
//                 const adminProfit = 0.1 * product.productrevenue; // 10% of revenue
//                 const profitPercentage = (adminProfit / totalRevenue) * 100;
//                 return {
//                   idproduct: product.idproduct,
//                   productrevenue: product.productrevenue,
//                   adminProfit: adminProfit,
//                   profitPercentage: profitPercentage.toFixed(2) // Convert to percentage and format to 2 decimal places
//                 };
//               });
    
//               // Combine total revenue and product results with admin profit
//               const combinedData = {
//                 totalRevenue: totalResults[0].totalrevenue,
//                 productsWithAdminProfit: resultsWithAdminProfit
//               };
    
//               if (!res.headersSent) {
//                 res.status(200).json(combinedData); // Send combined data
//               }
//             }
//           });
//         }
//       });
//     }




addRatingProduct(req, res) {

  
  const { userId, ratings } = req.body;

  return new Promise((resolve, reject) => {
    const insertQueries = [];
    const updateQueries = [];

    console.log(userId);
    console.log(ratings);

    ratings.forEach((ratingV) => {
      const { plant_id, rating } = ratingV;
      console.log(plant_id, rating);

  
      db.query(
        'SELECT rating_id FROM productrating WHERE user_id = ? AND plant_id = ?',
        [userId, plant_id],
        (err, results) => {
          if (err) {
            console.error(err);
            return reject('Failed to fetch interactions');
          }

          if (results.length == 0) {
         
            db.query(
              'INSERT INTO productrating (user_id, plant_id, rating) VALUES (?, ?, ?)',
              [userId, plant_id, rating],
              (error2, results2) => {
                if (error2) {
                  console.error(error2);
                  return reject('Failed to store rating');
                } else {
         
                  db.query(
                    `UPDATE plant p
                    JOIN (
                      SELECT plant_id, AVG(rating) AS avg_rating
                      FROM productrating
                      WHERE plant_id = ?
                      GROUP BY plant_id
                    ) pr ON p.id = pr.plant_id
                    SET p.average_rating = pr.avg_rating
                    WHERE p.id = ?`,
                    [plant_id, plant_id],
                    (error3, results3) => {
                      if (error3) {
                        console.error(error3);
                        return reject('Failed to update average rating');
                      }
                    }
                  );
                }
              }
            );
          } else {
      
            db.query(
              'UPDATE productrating SET rating = ? WHERE user_id = ? AND plant_id = ?',
              [rating, userId, plant_id],
              (error2, results2) => {
                if (error2) {
                  console.error(error2);
                  return reject('Failed to update rating');
                } else {
              
                  db.query(
                    `UPDATE plant  p
                    JOIN (
                      SELECT plant_id, AVG(rating) AS avg_rating
                      FROM productrating
                      WHERE plant_id = ?
                      GROUP BY plant_id
                    ) pr ON p.id = pr.plant_id
                    SET p.average_rating = pr.avg_rating
                    WHERE p.id = ?`,
                    [plant_id, plant_id],
                    (error3, results3) => {
                      if (error3) {
                        console.error(error3);
                        return reject('Failed to update average rating');
                      }
                    }
                  );
                }
              }
            );
          }
        }
      );
    });

    return resolve('Rated the product successfully');
  });
}


  
  


incrementshopcart = (req, res) => {
  const { user_id, plant_id } = req.body;

  const query = `
    UPDATE shopping_cart
    JOIN plant ON shopping_cart.plant_id = plant.id
    SET shopping_cart.item = shopping_cart.item + 1
    WHERE shopping_cart.user_id = ? 
      AND shopping_cart.plant_id = ? 
      AND shopping_cart.item + 1 <= plant.quantity;
  `;

  db.query(query, [user_id, plant_id], (error, results) => {
    if (error) {
      return res.status(500).json({ error: 'Database query error' });
    }
    if (results.affectedRows === 0) {
      return res.status(400).json({ message: 'Cannot increment item count. Either the plant does not exist, the user does not exist, or the item count exceeds plant quantity.' });
    }
    res.status(200).json({ message: 'Item count incremented successfully' });

    
  });
};



decrementshopcart = (req, res) => {
  const { user_id, plant_id } = req.body;

  const query = `
    UPDATE shopping_cart
    JOIN plant ON shopping_cart.plant_id = plant.id
    SET shopping_cart.item = shopping_cart.item - 1
    WHERE shopping_cart.user_id = ? 
      AND shopping_cart.plant_id = ? 
      AND shopping_cart.item - 1 >= 0
  `;

  db.query(query, [user_id, plant_id], (error, results) => {
    if (error) {
      return res.status(500).json({ error: 'Database query error' });
    }
    if (results.affectedRows === 0) {
      return res.status(400).json({ message: 'Cannot decrement item count. Either the plant does not exist, the user does not exist, or the item count is already at zero.' });
    }
    res.status(200).json({ message: 'Item count decremented successfully' });
  });
};
  
  
  
  


}

module.exports = PlantRepository;