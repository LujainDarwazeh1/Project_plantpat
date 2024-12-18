const mysql = require('mysql2');


const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '123456',
  database: 'plantpat',
});

class PaymentRepository {
  // addPayment(req, res) {
  //   return new Promise((resolve, reject) => {
  //     const { user_id, amount, payment_method, delivery_option, cart_ids } = req.body;
  
  //     
  //     if (!user_id || !amount || !payment_method || !delivery_option || !cart_ids || cart_ids.length === 0) {
  //       return reject('Invalid input parameters');
  //     }
  
  //     
  //     db.beginTransaction((err) => {
  //       if (err) return reject('Transaction start error');
  
  //       
  //       db.query("SELECT * FROM shopping_cart WHERE user_id = ?", [user_id], (error, results) => {
  //         if (error) {
  //           return db.rollback(() => {
  //             reject('Failed to retrieve shopping cart items');
  //           });
  //         }
  
  //         if (results.length === 0) {
  //           return db.rollback(() => {
  //             reject('No products in shopping cart');
  //           });
  //         }
  
  //         
  //         const validCartIds = cart_ids.filter(id => id !== 0 && id !== undefined);
  //         if (validCartIds.length === 0) {
  //           return db.rollback(() => {
  //             reject('No valid cart IDs');
  //           });
  //         }
  
  //         
  //         const insertPaymentQueries = validCartIds.map(cartId =>
  //           new Promise((resolve, reject) => {
  //             const product = results.find(item => item.cart_id === cartId);
  //             if (!product) return reject('Product not found in cart');
  
  //             db.query(
  //               'INSERT INTO pay (user_id, payment_date, amount, payment_method, plantid, delivery_option) VALUES (?, ?, ?, ?, ?, ?)',
  //               [user_id, new Date(), amount, payment_method, product.plant_id, delivery_option],
  //               (error) => {
  //                 if (error) return reject('Failed to insert payment');
  //                 resolve();
  //               }
  //             );
  //           })
  //         );
  
  //        
  //         Promise.all(insertPaymentQueries)
  //           .then(() => {
  //          
  //             db.commit((err) => {
  //               if (err) {
  //                 return db.rollback(() => {
  //                   reject('Commit error');
  //                 });
  //               }
  //               resolve('Payment processed successfully');
  //             });
  //           })
  //           .catch((error) => {
  //           
  //             db.rollback(() => {
  //               reject(error);
  //             });
  //           });
  //       });
  //     });
  //   });
  // }




  addPayment(req, res) {
    return new Promise((resolve, reject) => {
      const { user_id, amount, payment_method, delivery_option, cart_ids, count } = req.body;
  
    
      if (!user_id || !amount || !payment_method || !delivery_option || !cart_ids || cart_ids.length === 0 || !count || count.length === 0) {
        return reject('Invalid input parameters');
      }
  
     
      db.beginTransaction((err) => {
        if (err) return reject('Transaction start error');
  
       
        db.query("SELECT * FROM shopping_cart WHERE user_id = ?", [user_id], (error, results) => {
          if (error) {
            return db.rollback(() => {
              reject('Failed to retrieve shopping cart items');
            });
          }
  
          if (results.length === 0) {
            return db.rollback(() => {
              reject('No products in shopping cart');
            });
          }
  
          
          const validCartIds = cart_ids.filter(id => id !== 0 && id !== undefined);
          if (validCartIds.length === 0) {
            return db.rollback(() => {
              reject('No valid cart IDs');
            });
          }
  
         
          const insertPaymentQueries = validCartIds.map((cartId, index) =>
            new Promise((resolve, reject) => {
              const product = results.find(item => item.cart_id === cartId);
              if (!product) return reject('Product not found in cart');
  
              const plantCount = count[index] || 1;  
  
              db.query(
                'INSERT INTO pay (user_id, payment_date, amount, payment_method, plantid, delivery_option, count) VALUES (?, ?, ?, ?, ?, ?, ?)',
                [user_id, new Date(), amount, payment_method, product.plant_id, delivery_option, plantCount],
                (error) => {
                  if (error) return reject('Failed to insert payment');
                  resolve();
                }
              );
            })
          );
  
         
          Promise.all(insertPaymentQueries)
            .then(() => {
             
              db.commit((err) => {
                if (err) {
                  return db.rollback(() => {
                    reject('Commit error');
                  });
                }
                resolve('Payment processed successfully');
              });
            })
            .catch((error) => {
             
              db.rollback(() => {
                reject(error);
              });
            });
        });
      });
    });
  }
  
  
   


 /////
  fetchPlantQuantity(plant_id) {
  return new Promise((resolve, reject) => {
    db.query('SELECT quantity FROM plant WHERE id = ?', [plant_id], (error, results) => {
      if (error) {
        console.error(`Error fetching plant quantity for plant_id ${plant_id}:`, error);
        reject(`Failed to fetch plant quantity for plant_id ${plant_id}`);
      } else {
        if (results.length === 0) {
          reject(`Plant with id ${plant_id} not found`);
        } else {
          resolve(results[0].quantity);
        }
      }
    });
  });
}




AllPayment = () => {
  const query = `
SELECT 
    user_id,
    amount,
    payment_date,
    payment_method,
    delivery_option,
    GROUP_CONCAT(plantid ORDER BY plantid SEPARATOR ',') AS products,
    GROUP_CONCAT(count ORDER BY plantid SEPARATOR ',') AS counts
FROM 
    pay
GROUP BY 
    user_id, amount, payment_date, payment_method, delivery_option
ORDER BY 
    payment_date DESC;

`;


  return new Promise((resolve, reject) => {
    db.query(query, (error, results) => {
      if (error) {
        return reject(error);
      }
      resolve(results);
    });
  });
};


  updatePlantQuantity = (plant_id, newQuantity) => {
  return new Promise((resolve, reject) => {
    db.query('UPDATE plant SET quantity = ? WHERE id = ?', [newQuantity, plant_id], (error, results) => {
      if (error) {
        console.error(`Error updating plant quantity for plant_id ${plant_id}:`, error);
        reject(`Failed to update plant quantity for plant_id ${plant_id}`);
      } else {
        resolve(`Plant quantity updated successfully for plant_id ${plant_id}`);
      }
    });
  });
};










updateTheQuantityToPayment(req, res) {
  const { cart_ids, user_id } = req.body; 
  const updatePromises = [];

  return new Promise((resolve, reject) => {
    cart_ids.forEach(cart_id => {
   
      db.query('SELECT plant_id, item FROM shopping_cart WHERE cart_id = ? AND user_id = ?', [cart_id, user_id], (error, results) => {
        if (error) {
          console.error(`Error fetching shopping cart details for cart_id ${cart_id} and user_id ${user_id}:`, error);
          reject(`Failed to fetch shopping cart details for cart_id ${cart_id} and user_id ${user_id}`);
        } else {
          if (results.length === 0) {
            console.warn(`No shopping cart details found for cart_id ${cart_id} and user_id ${user_id}`);
          } else {
            results.forEach(row => {
              const { plant_id, item } = row;
             
              this.fetchPlantQuantity(plant_id)
                .then(currentQuantity => {
                  if (currentQuantity < item) {
                    throw new Error(`Not enough quantity available for plant_id ${plant_id}`);
                  }
                  const newQuantity = currentQuantity - item;
                 
                  updatePromises.push(this.updatePlantQuantity(plant_id, newQuantity));
                })
                .catch(error => {
                  console.error(error);
                  reject(error); 
                });
            });
          }
        }
      });
    });

  
    Promise.all(updatePromises)
      .then(() => {
        resolve('Plant quantities updated successfully');
      })
      .catch(error => {
        console.error('Failed to update plant quantities:', error);
        reject('Failed to update plant quantities');
      });
  });
}






updatestatus = (req, res) => {
  const { userid, amount, payment_method } = req.body;

  const query = `
    UPDATE pay
    SET status = 'Completed'
    WHERE user_id = ? AND amount = ? AND payment_method = ? AND delivery_option = 'Our delivery system'
  `;

  return new Promise((resolve, reject) => {
    db.query(query, [userid, amount, payment_method], (err, results) => {
      if (err) {
        return reject(err);
      }
      if (results.affectedRows > 0) {
        resolve('Payment status updated successfully');
      } else {
        resolve('No matching records found to update');
      }
    });
  });
};

deleteFromShopCart(cartIds, userId) {
  return new Promise((resolve, reject) => {
   
    const cartIdArray = cartIds.split(',').map(id => parseInt(id, 10));

    if (cartIdArray.includes(NaN)) {
      return reject('Invalid cart_id values');
    }

    
    db.beginTransaction((err) => {
      if (err) {
        return reject('Failed to start transaction');
      }

     
      db.query('DELETE FROM payment_cart WHERE cart_id IN (?)', [cartIdArray], (error, paymentResults) => {
        if (error) {
          return db.rollback(() => {
            console.error('Error deleting from payment_cart:', error);
            reject('Failed to delete item from payment_cart');
          });
        }

       
        db.query('DELETE FROM pay WHERE payment_id IN (SELECT payment_id FROM payment_cart WHERE cart_id IN (?))', [cartIdArray], (error, payResults) => {
          if (error) {
            return db.rollback(() => {
              console.error('Error deleting from pay:', error);
              reject('Failed to delete item from pay');
            });
          }

        
          db.query('DELETE FROM shopping_cart WHERE cart_id IN (?) AND user_id = ?', [cartIdArray, userId], (error, deleteResults) => {
            if (error) {
              return db.rollback(() => {
                console.error('Error deleting from shopping_cart:', error);
                reject('Failed to delete item from shopping_cart');
              });
            } else if (deleteResults.affectedRows === 0) {
              console.log(`Deleted ${deleteResults.affectedRows} row(s) from shopping_cart`);
              return db.rollback(() => {
                reject('Item not found in the shopping cart');
              });
            } else {
              console.log(`Deleted ${deleteResults.affectedRows} row(s) from shopping_cart`);

             
              db.commit((err) => {
                if (err) {
                  return db.rollback(() => {
                    console.error('Failed to commit transaction:', err);
                    reject('Failed to commit transaction');
                  });
                }

                resolve('Item deleted successfully');
              });
            }
          });
        });
      });
    });
  });
}





checkTheQuantityToPayment (userId) {
  return new Promise((resolve, reject) => {
    console.log("Fetching cart items for user:", userId);
    
    db.query('SELECT plant_id FROM shopping_cart WHERE user_id = ?', [userId], (error, results) => {
      if (error) {
        console.error("Error retrieving cart items:", error);
        reject('Failed to retrieve cart items');
      } else if (results.length === 0) {
        console.log("No items found in shopping cart for user:", userId);
        reject('No items in cart');
      } else {
        const promises = results.map((cartRow) => {
          const plantId = cartRow.plant_id;
          return new Promise((resolveQuery, rejectQuery) => {
            db.query('SELECT * FROM plant WHERE id = ?', [plantId], (error1, res1) => {
              if (error1) {
                console.error("Error retrieving plant details:", error1);
                rejectQuery('Failed to retrieve plant details');
              } else if (res1.length === 0) {
                console.log("No plant found with id:", plantId);
                rejectQuery('Plant not found');
              } else {
                console.log("Plant details retrieved:", res1);
              
                resolveQuery(res1);
              }
            });
          });
        });

        Promise.all(promises)
          .then((allProductData) => {
            console.log("All product data retrieved:", allProductData);
            resolve({ results, allProductData });
          })
          .catch((error2) => {
            console.error("Error processing plant queries:", error2);
            reject('Failed to process plant queries');
          });
      }
    });
  });
};
























}







module.exports = PaymentRepository;