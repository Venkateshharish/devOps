module.exports = {
  HOST: "tutorial-mysql-db.cwsoddk4atbk.us-east-1.rds.amazonaws.com",
  USER: "root",
  PASSWORD: "12345678",
  DB: "tutorials",
  dialect: "mysql",
  pool: {
    max: 5,
    min: 0,
    acquire: 30000,
    idle: 10000
  }
};
