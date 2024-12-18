const { Sequelize } = require('sequelize');
const sequelize = new Sequelize({
  dialect: 'mysql',
  host: 'localhost',
  username: 'root',
  password: '123456',
  database: 'plantpat',
  logging: console.log, // Enable logging
});


async function testDatabaseConnection() {
  try {
    await sequelize.authenticate();
    console.log('Database connection has been established successfully.');
  } catch (error) {
    console.error('Unable to connect to the database:', error);
  }
}

testDatabaseConnection();

module.exports = { sequelize, Sequelize };
