import { config } from "dotenv";

config();

export default {
  host: process.env.HOST || "",
  user: process.env.USER || "",
  port: process.env.PORT || "",
  password: process.env.PASSWORD || "",
  database: process.env.DATABASE || ""
}
