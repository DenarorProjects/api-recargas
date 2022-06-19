import express from "express";
import morgan from "morgan";

// * Routes
import recargaRoutes from "./routes/recarga.routes";


const app = express();

// * Settings
app.set('port', 4000);

// * Middlewares
app.use(morgan('dev'));
app.use(express.json());

// * Routes
app.use('/api/dencel', recargaRoutes);

export default app;
