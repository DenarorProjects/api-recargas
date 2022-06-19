import mysql from 'promise-mysql';
import config from '../config';

const conn = mysql.createConnection({
  host: config.host,
  user: config.user,
  password: config.password,
  database: config.database,
  multipleStatements: true
  // port: config.port
});

const getConnection = () => {
  return conn;
};

module.exports = {
  getConnection
};
