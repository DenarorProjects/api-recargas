import { config } from "dotenv";

config();

export default {
  host: process.env.DB_HOST || "",
  user: process.env.DB_USER || "",
  port: process.env.DB_PORT || "",
  password: process.env.DB_PASSWORD || "",
  database: process.env.DB_DATABASE || "",
  token: process.env.TOKEN || "",
}
