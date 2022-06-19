import express from "express";
import morgan from "morgan";
import config from './config';


const token = config.token;
// * Routes
import recargaRoutes from "./routes/recarga.routes";

const app = express();

// * Settings
app.set('port', 4000);

app.use((req, res, next) => {
  if (req.method === 'OPTIONS') {
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'GET, POST, DELETE');
    res.set("Access-Control-Allow-Headers", "content-type,token");
    res.set('Access-Control-Max-Age', '86400');
    res.status(200).send('OK');
  } else {
    next();
  }
});

app.use((req, res, next) => {
  if (!req.headers.token || token !== req.headers.token) {
    return res.status(403).send('No token provided');
  }
  return next();
})


// * Middlewares
app.use(morgan('dev'));
app.use(express.json());

// * Routes
app.use('/api/dencel', recargaRoutes);

export default app;
