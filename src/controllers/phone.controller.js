import { getConnection } from '../database/database';

const getPhones = async (req, res) => {
  try {
    const conn = await getConnection();
    const result = await conn.query('SELECT * FROM phone_number');
    res.json(result);
  } catch (error) {
    res.status(500);
    res.send(error.message)
  }
};

const getPhoneByNumPhone = async (req, res) => {
  try {
    const { num } = req.params;
    const conn = await getConnection();
    const query = 'call obtener_telefono_por_num_telefono(?);';

    const [result, { }] = await conn.query(query, [num]);

    res.json(result);
  } catch (error) {
    res.status(500);
    res.send({
      res: -1,
      message: error.message
    })
  }
};
const addPhoneNumber = async (req, res) => {
  try {
    const { dni, amount, plan } = req.body;
    const conn = await getConnection();

    const query = 'call agregar_telefono(?,?,?, @result, @phone); SELECT @result, @phone;';

    const [{ }, [rst]] = await conn.query(query, [dni, amount, plan]);

    const result = parseInt(rst['@result'].toString(), 10);

    if (result !== 1) {
      res.json({
        res: result,
        message: 'DNI no existente'
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

const updateBalanceMovil = async (req, res) => {
  try {

    const { number_phone, date_register, amount } = req.body;
    const conn = await getConnection();

    const query = 'call recargar_telefono(?,?,?, @result); SELECT @result;';

    const [{ }, [rst]] = await conn.query(query, [number_phone, date_register, amount]);
    console.log('Denn ~> updateBalanceMovil ~> rst: ', rst);

    const result = parseInt(Object.values(rst).toString(), 10);

    res.json({
      res: result,
      message: result === 1 ? 'Se realizó la recarga exitosamentes' : 'No se encontró el número de telefono ingresado'
    });

  } catch (error) {
    res.status(500);
    res.send({
      res: -1,
      message: error.message
    })
  }
};

export const methods = {
  getPhones,
  addPhoneNumber,
  updateBalanceMovil,
  getPhoneByNumPhone
};
