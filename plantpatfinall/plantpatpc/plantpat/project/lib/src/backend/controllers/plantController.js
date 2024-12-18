const plantRep = require('../data/database/PlantRepo');
const plant = new plantRep();







exports.addPlant = (req, res) => {
  console.log("hello from com=ntroller");

  plant.addPlant(req, res)
    .then((message) => {
      res.status(201).json({ message });
    })
    .catch((error) => {
      res.status(400).json({ message: error.message || 'Failed to add plant' });
    });
};

exports.AddSection = (req, res) => {
  console.log("hello from controller");

  plant.AddSection(req, res)
    .then((message) => {
      res.status(201).json({ message });
    })
    .catch((error) => {
      res.status(400).json({ message: error.message || 'Failed to add section' });
    });
};





exports.Sectionidbyname = (req, res) => {
  const { sectionname } = req.query;

  console.log('Received query parameter: sectionname =', sectionname);

  if (!sectionname) {
    console.log('Error: Section name is not provided');
    return res.status(400).json({ message: 'Section name is required' });
  }

  plant.getSectionIdByName(sectionname)
    .then(sectionId => {
      console.log('Fetched section ID:', sectionId); 
      res.json({ sectionid: sectionId });
    })
    .catch(error => {
      console.error('Error in getSectionIdByName:', error); 
      if (error.message === 'Section not found') {
        return res.status(404).json({ message: error.message });
      }
      return res.status(500).json({ message: 'Internal Server Error' });
    });
};





    exports.addSection = (req, res) => {
      plant
        .addSection(req, res) 
        .then((message) => {
          res.status(201).json({ message });
        })
        .catch((error) => {
          res.status(400).json({ message: error.message || 'Failed to add section' });
        });
    };
    exports.updateSection = (req, res) => {
     
      plant.updateSection(req, res)
        .then((message) => {
          res.status(200).json({ message });
        })
        .catch((error) => {
          res.status(400).json({ message: error.message || 'Failed to update section' });
        });
    };

    exports.updatePlant = (req, res) => {
    
      plant.updatePlant(req, res)
        .then((message) => {
          res.status(200).json({ message });
        })
        .catch((error) => {
          res.status(400).json({ message: error.message || 'Failed to update plant' });
        });
    };

    exports.deleteSection = (req, res) => {
      const { sectionId } = req.query; 
    
      if (!sectionId) {
        return res.status(400).json({ message: 'sectionId is required' });
      }
    
      plant.deleteSection(sectionId)
        .then((message) => {
          res.status(200).json({ message });
        })
        .catch((error) => {
          res.status(400).json({ message: error.message || 'Failed to delete section' });
        });
    };
    
    
    exports.deletePlant = (req, res) => {
      const { plantId } = req.query; 
    
      if (!plantId) {
        return res.status(400).json({ message: 'plantId is required' });
      }
    
      plant.deletePlant(plantId)
        .then((message) => {
          res.status(200).json({ message });
        })
        .catch((error) => {
          res.status(400).json({ message: error.message || 'Failed to delete plant' });
        });
    };

    exports.addToShopCart = (req, res) => {
      console.log("hello from controller");
      plant
        .addToShopCart(req, res)
        .then((message) => {
          res.status(201).json({ message });
        })
        .catch((error) => {
          res.status(400).json({ message: error });
        });
    };


    exports.updateItemOnShopCart = (req, res) => {
      console.log("hello from controller");
    
      plant.updateItemOnShopCart(req, res)
        .then((message) => {
          console.log(message);
          res.status(201).json({ message }); 
        })
        .catch((error) => {
          res.status(400).json({ message: error }); 
        });
    };

    exports.getSections = (req, res) => {
      plant.getSections(req, res);
    };



    exports.getallSectionName = (req, res) => {
      plant.getallSectionName(req, res);
    };

    




    exports.getSectionName = async (req, res) => {
      try {
        const { id } = req.query;
        const sectionName = await plant.getSectionName(id); 
    
        if (sectionName !== null) { 
          res.status(200).json({ name: sectionName });
        } else {
          res.status(404).json({ message: 'Section not found' });
        }
      } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
      }
    };
    

    

      exports.getPlants = (req, res) => {
        plant.getPlants(req, res);
        };

        exports.addToWishList = (req, res) => {
          plant.addToWishList(req, res)
            .then((message) => {
              res.status(201).json({ message });
            })
            .catch((error) => {
              res.status(400).json({ message: error });
            });
        };

        exports.getprice = (req, res) => {
          const { id } = req.query;
          console.log({ id });
      
          plant.getprice(id)
              .then((price) => {
                  console.log({ price });
                  console.log('Price:', price);
                  res.status(200).json(price);
              })
              .catch((error) => {
                  console.error({ error });
                  res.status(500).json({ message: 'Internal server error' });
              });
      };

      exports.plantThisMonth = (req, res) => {
        plant.plantThisMonth(req, res)
            .then((res1) => {
                console.log({ res1 });
                res.status(200).json(res1);
            })
            .catch((error) => {
                console.error({ error });
                res.status(500).json({ message: 'Not have thing to retrieve' });
            });
    };


    exports.popularity = (req, res) => {
      plant.popularity(req, res)
          .then((res1) => {
              console.log({ res1 });
              res.status(200).json(res1);
          })
          .catch((error) => {
              console.error({ error });
              res.status(500).json({ message: 'Not have thing to retrieve' });
          });
  };
    
        

    exports.retriveplantHomeRecomendedSystem = (req, res) => {
      const { userId } = req.query;


      plant.retriveplantHomeRecomendedSystem(userId)
          .then((res1) => {
              console.log({res1});

              res.status(200).json(res1);
          })
          .catch((error) => {
              console.error({error});
              res.status(500).json({ message: 'Not have thing to retrieve' });
          });
    };

    exports.retriveWordOfsearch = (req, res) => {
      const { name } = req.query;
      
  
      plant.retriveWordOfsearch(name)
          .then((res1) => {
              console.log({res1});
            
              res.status(200).json(res1);
          })
          .catch((error) => {
              console.error({error});
              res.status(500).json({ message: 'Not have thing to retrieve' });
          });
  };


  exports.retriveProductOfsearch = (req, res) => {
    const { name } = req.query;
    
  
    plant.retriveProductOfsearch(name)
        .then((res1) => {
            console.log({res1});
          
            res.status(200).json(res1);
        })
        .catch((error) => {
            console.error({error});
            res.status(500).json({ message: 'Not have thing to retrieve' });
        });
  };

  exports.retriveFromWishList = (req, res) => {
    const { userId } = req.query;

    plant.retriveFromWishList(userId)
        .then((result) => {
            console.log({result});

            res.status(200).json(result);
        })
        .catch((error) => {
            console.error({error});
            res.status(500).json({ message: 'Internal server error' });
        });
    };




      exports.deleteFromWishList = (req, res) => {
        const plantId = req.query.plantId; 
        const userId = req.query.userId;

        plant.deleteFromWishList(plantId,userId)
            .then((result) => {
                console.log('Item deleted successfully');
                res.status(200).json({ message: 'Item deleted successfully' });
            })
            .catch((error) => {
                console.error('Error deleting item:', error);
                res.status(500).json({ message: 'Internal server error' });
            });
    };
    
    


  


  exports.getplantimage = (req, res) => {
    const { plantId } = req.query;
    console.log({plantId});

    plant.getplantimage(plantId)
        .then((image) => {
            console.log({image});

            res.status(200).json(image);
        })
        .catch((error) => {
            console.error({error});
            res.status(500).json({ message: 'Internal server error' });
        });
};


exports.getPlantImage = (req, res) => {
  const plantId = req.query.id; 

  
  if (!plantId) {
    return res.status(400).json({ error: 'Plant ID is required' });
  }


  plant.getPlantById(plantId, (error, plantData) => {
    if (error) {
      console.error('Error fetching plant image data:', error);
      return res.status(500).json({ error: 'Internal Server Error' });
    }
    
    if (plantData) {
   
      res.json({ image: plantData.image });
    } else {
      res.status(404).json({ error: 'Plant not found' });
    }
  });
};


exports.findSimilar = (req, res) => {
  const { plantId } = req.query;

  plant.findSimilar(plantId)
      .then((result) => {
          console.log({ result });
          res.status(200).json(result);
      })
      .catch((error) => {
          console.error({ error });
          res.status(500).json({ message: 'Internal server error' });
      });
};

exports.getToShopCart = (req, res) => {
  const userId = req.query.userId;

  plant.getToShopCart(userId)
    .then((res1) => {
      console.log('Cart items:', res1);
      res.status(200).json(res1);
    })
    .catch((error) => {
      console.error('Error retrieving cart items:', error);
      res.status(500).json({ message: 'Not have data in database to retrieve' });
    });
};


exports.incrementshopcart = (req, res) => {
  const { user_id, plant_id } = req.body;

  if (!user_id || !plant_id) {
    return res.status(400).json({ message: 'User ID and Plant ID are required' });
  }

  plant.incrementshopcart(req, res);
};









exports.decrementshopcart = (req, res) => {
  const { user_id, plant_id } = req.body;

  if (!user_id || !plant_id) {
    return res.status(400).json({ message: 'User ID and Plant ID are required' });
  }

  plant.decrementshopcart(req, res);
};







exports.deleteFromShopCart = (req, res) => {
  const plantId = req.query.plantId; 
  const userId = req.query.userId; 

  if (!plantId || !userId) {
      return res.status(400).json({ message: 'Plant ID and User ID are required' });
  }


  plant.deleteFromShopCart(plantId, userId)
      .then((result) => {
          console.log('Item deleted successfully');
          res.status(200).json({ message: 'Item deleted successfully' });
      })
      .catch((error) => {
          console.error('Error deleting item:', error);
          res.status(500).json({ message: 'Internal server error' });
      });
};


exports.updateItemOnShopCart = (req, res) => {
  plant
  .updateItemOnShopCart(req, res)
  .then((message) => {
    console.log(message);
    res.status(201).json({ message }); 
  })
  .catch((error) => {
    res.status(400).json({ message: error }); 
  });
};





exports.totalnumberproductforstatistics= (req, res) => {

  

  plant.totalnumberproductforstatistics(req, res);
  
};


exports.totalnumbersoldproduct = (req, res) => {
  plant.totalNumberSoldProduct()
    .then((totalSold) => {
      res.status(200).json({ total_sold: totalSold });
    })
    .catch((err) => {
      console.error('Error retrieving total sold products:', err);
      res.status(500).json({ error: 'Internal server error' });
    });
};




exports.paymentsPerPlant = (req, res) => {
  plant.paymentsPerPlant()
    .then((result) => {
      res.status(200).json(result);
    })
    .catch((err) => {
      console.error('Error retrieving payments per plant:', err);
      res.status(500).json({ error: 'Internal server error' });
    });
};




    //


    exports.totalRevenue = (req, res) => {
      plant.totalRevenue()
        .then((totalRevenue) => {
          res.status(200).json({ total_revenue: totalRevenue });
        })
        .catch((err) => {
          console.error('Error calculating total revenue:', err);
          res.status(500).json({ error: 'Internal server error' });
        });
    };




    exports.BestSelling = async (req, res) => {
      try {
      
        const result = await plant.getBestSellingPlants();
        
      
        res.json(result);
      } catch (err) {
        
        res.status(500).json({ error: err.message });
      }
    };


    exports.RecetOrders = async (req, res) => {
      try {
        const result = await plant.getRecentOrders();
        res.json(result); 
      } catch (err) {
        res.status(500).json({ error: err.message }); 
      }
    };


   



    exports.updateplant = function(req, res) {
      var { id, name, description, size, height, price, quantity, image } = req.body;
    
      plantRepository.updateplant(id, name, description, size, height, price, quantity, image)
        .then(function(message) {
          res.status(200).json({ message });
        })
        .catch(function(error) {
          res.status(500).json({ error: error.message }); 
        });
    };

    exports.getPlantbyid = (req, res) => {
      const plant_id = req.query.plant_id;
      
     
      if (!plant_id) {
        return res.status(400).json({ error: 'Plant ID is required' });
      }
    
      plant.getPlantbyid(plant_id)
        .then((plant) => {
          if (plant.length > 0) {
            res.status(200).json(plant[0]); 
          } else {
            res.status(404).json({ message: 'Plant not found' });
          }
        })
        .catch((error) => {
          res.status(500).json({ error: error.message });
        });
    };




    exports.plantnamebyid = (req, res) => {
      const plant_id = req.query.plant_id;
      
   
      if (!plant_id) {
        return res.status(400).json({ error: 'Plant ID is required' });
      }
    
      plant.plantnamebyid(plant_id)
        .then((plant) => {
          if (plant.length > 0) {
            res.status(200).json(plant[0]); 
          } else {
            res.status(404).json({ message: 'Plant not found' });
          }
        })
        .catch((error) => {
          res.status(500).json({ error: error.message });
        });
    };



    
    




    exports.totalorder = (req, res) => {
      plant.totalOrder()  
        .then((totalOrders) => {  
          res.status(200).json({ total_orders: totalOrders });  
        })
        .catch((err) => {
          console.error('Error calculating total orders:', err);  
          res.status(500).json({ error: 'Internal server error' });
        });
    };
    

    

    exports.paymentsPerSection = (req, res) => {
      plant.paymentsPerSection()
        .then((result) => {
          res.status(200).json(result);
        })
        .catch((err) => {
          console.error('Error retrieving payments per section:', err);
          res.status(500).json({ error: 'Internal server error' });
        });
    };


    exports.ProductNewCollectionForNotification = (req, res) => {
      const { userId } = req.query;
    
      plant.ProductNewCollectionForNotification(userId)
          .then((result) => {
              console.log({result});
    
              res.status(200).json(result);
          })
          .catch((error) => {
              console.error({error});
              res.status(500).json({ message: 'Internal server error' });
          });
      };



      exports.checkQuantityForNotification = (req, res) => {
        const { userId } = req.query;
  
  
        plant.checkQuantityForNotification(userId)
            .then((result) => {
                console.log({result});
  
                res.status(200).json(result);
            })
            .catch((error) => {
                console.error({error});
                res.status(500).json({ message: 'Internal server error' });
            });
        };


        exports.addRatingProduct = (req, res) => {
          plant
            .addRatingProduct(req, res)
            .then((message) => {
              res.status(201).json({ message }); 
            })
            .catch((error) => {
              res.status(400).json({ message: error }); 
            });
          }


     exports.updatePlantNameById = (req, res) => {
      const { name, id } = req.query; 
  
    
      if (!name || !id) {
          return res.status(400).json({ message: "Name and ID are required" });
      }
  
    
      plant.updatePlantNameById(name, id)
          .then(result => {
             
              if (result.affectedRows > 0) {
                  res.status(200).json({ message: "Plant name updated successfully" });
              } else {
                  res.status(404).json({ message: "Plant not found" });
              }
          })
          .catch(error => {
              console.error("Error updating plant name:", error);
              res.status(500).json({ message: "Internal server error" });
          });
  };

      
  exports.updatePlantPriceById = (req, res) => {
    const { price, id } = req.query; 
  
    
    if (!price || !id) {
      return res.status(400).json({ message: "Price and ID are required" });
    }
  
    
    const priceValue = parseFloat(price);
    if (isNaN(priceValue)) {
      return res.status(400).json({ message: "Invalid price value" });
    }
  
   
    plant.updatePlantPriceById(priceValue, id)
      .then(result => {
       
        if (result.affectedRows > 0) {
          res.status(200).json({ message: "Plant price updated successfully" });
        } else {
          res.status(404).json({ message: "Plant not found" });
        }
      })
      .catch(error => {
        console.error("Error updating plant price:", error);
        res.status(500).json({ message: "Internal server error" });
      });
  };



exports.updatePlantQuantityById = (req, res) => {
  const { quantity, id } = req.query; 


  if (!quantity || !id) {
    return res.status(400).json({ message: "Quantity and ID are required" });
  }


  const parsedQuantity = parseInt(quantity, 10);
  if (isNaN(parsedQuantity)) {
    return res.status(400).json({ message: "Invalid quantity" });
  }

 
  plant.updatePlantQuantityById(parsedQuantity, id)
    .then(result => {
     
      if (result.affectedRows > 0) {
        res.status(200).json({ message: "Plant quantity updated successfully" });
      } else {
        res.status(404).json({ message: "Plant not found" });
      }
    })
    .catch(error => {
      console.error("Error updating plant quantity:", error);
      res.status(500).json({ message: "Internal server error" });
    });
};


exports.addplantImage = async (req, res) => {
  try {
    const message = await plant.addplantImage(req);
    res.status(201).json({ message });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};
  


    
    
    
          exports.getPlantbysectionid = (req, res) => {
            const { id } = req.query; 
            plant.getPlantbysectionid(id, res); 
          };



          exports.getFavoriteStatus = (req, res) => {
            const { plantId, userId } = req.query;
          
            if (!plantId || !userId) {
              return res.status(400).json({ error: 'Missing plantId or userId' });
            }
          
            plant.getFavoriteStatus(plantId, userId, (err, isFavorite) => {
              if (err) {
                console.error('Error fetching favorite status:', err);
                return res.status(500).json({ error: 'Internal Server Error' });
              }
              res.json({ isFavorite });
            });
          };