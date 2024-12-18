
const express = require('express');
const bodyParser = require('body-parser');
const user = require('./routes/userRoute.js');
const plant = require('./routes/plantRoute.js');
const http = require('http');
const payment = require('./routes/paymentRoute.js');
const app = express();
const port = 3000;
const sessionConfig = require('./middlewares/sessionConfig'); // Import the session configuration module

app.use(sessionConfig);
app.use(express.json());

const cors = require('cors');
app.use(cors());




//





//

//app.use(bodyParser.json());


app.use((req, res, next) => {
  console.log(`Request URL: ${req.url}`);
  next();
});

app.use('/plantpat/user', user);
app.use('/plantpat/edit', user);
app.use('/plantpat/deleteaccount',user);

app.use('/plantpat/home', plant);
app.use('/plantpat/plant', plant); 

app.use('/plantpat/search',plant);

app.use('/plantpat/shoppingcart',plant);
app.use('/plantpat/manage',user);

app.use('/plantpat/totalnumproduct',plant);//statistic

app.use('/plantpat/payment',payment);


// const server = http.createServer(app);

// server.setTimeout(120000); // Set timeout to 2 minutes (120000 milliseconds)

// app.listen(port, () => {
//   console.log(`Server running at http://localhost:${port}`);
// });



const server = http.createServer(app);
server.setTimeout(120000); // Set timeout to 2 minutes (120000 milliseconds)

// Start the server
server.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});

// // Handle graceful shutdown
// process.on('SIGTERM', () => {
//   server.close(() => {
//     console.log('Process terminated');
//   });
// });

