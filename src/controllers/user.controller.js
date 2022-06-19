import { getConnection } from '../database/database';

const addUser = async (req, res) => {
  try {
    const { dni, name, lastname, amount } = req.body;
    const conn = await getConnection();

    const query = 'call agregar_usuario(?,?,?,?, @result, @phone); SELECT @result, @phone;';

    const [{ }, [rst]] = await conn.query(query, [dni, name, lastname, amount]);

    const result = parseInt(rst['@result'].toString(), 10);

    if (result !== 1) {
      res.json({
        res: result,
        message: 'DNI ya existe'
      });
    } else {
      const num = rst['@phone'].toString();
      res.json({
        res: result,
        dni: dni,
        new_phone: num
      });
    }
  } catch (error) {
    res.status(500);
    res.send({
      res: -1,
      message: error.message
    })
  }
};

const getPhonesByUser = async (req, res) => {
  try {
    const { dni } = req.params;
    const conn = await getConnection();
    const query = 'call obtener_telefonos_por_usuario(?);';

    const [result, { }] = await conn.query(query, [dni]);

    res.json(result);
  } catch (error) {
    res.status(500);
    res.send({
      res: -1,
      message: error.message
    })
  }
};
export const methods = {
  addUser,
  getPhonesByUser
};
