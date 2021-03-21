import bcrypt from 'bcrypt';
import pg from 'pg';
import dotenv from 'dotenv';

dotenv.config();

const {
  DATABASE_URL: connectionString,
  NODE_ENV: nodeEnv = 'development',
} = process.env;
const ssl = nodeEnv !== 'development' ? { rejectUnauthorized: false } : false;

const pool = new pg.Pool({ connectionString, ssl });

pool.on('error', (err) => {
  console.error('Unexpected error on idle client', err);
  process.exit(-1);
});

export async function query(q, values = []) {
  const client = await pool.connect();

  let result;

  try {
    result = await client.query(q, values);
  } catch (err) {
    console.error('Villa í query', err);
    throw err;
  } finally {
    client.release();
  }

  return result;
}

export async function updateUserAdmin(bool, id) {
  const q = 'UPDATE users SET admin = $1 WHERE id = $2 RETURNING *';
  const result = await query(q, [bool, id]);
  if (result.rowCount === 1) {
    return result.rows[0];
  }
  return false;
}

export async function comparePasswords(password, hash) {
  const result = await bcrypt.compare(password, hash);
  return result;
}

export async function findByUsername(username) {
  const q = 'SELECT * FROM users WHERE username = $1';
  try {
    const result = await query(q, [username]);

    if (result.rowCount === 1) {
      return result.rows[0];
    }
  } catch (e) {
    console.error('Gat ekki fundið notanda eftir notendnafni');
    return null;
  }

  return false;
}

export async function findById(id) {
  const q = 'SELECT * FROM users WHERE id = $1';

  try {
    const result = await query(q, [id]);

    if (result.rowCount === 1) {
      return result.rows[0];
    }
  } catch (e) {
    console.error('Gat ekki fundið notanda eftir id');
  }

  return null;
}
export async function getUsersTotal() {
  const q = `
  SELECT count(*) as total FROM users
`;
  try {
    const result = await query(
      q, [],
    );
    return result.rows[0];
  } catch (e) {
    console.error(e);
  }
  return null;
}
export async function updateUser(email, password, id) {
  let max = 0;
  let i = 0;
  let result = null;
  if (email) {
    max += 1;
    const q = 'UPDATE users SET email = $1 WHERE id = $2 RETURNING *';
    result = await query(q, [email, parseInt(id, 10)]);
    i += result.rowCount;
  }
  if (password) {
    const hashedPassword = await bcrypt.hash(password, 11);
    const q2 = 'UPDATE users SET password = $1 WHERE id = $2 RETURNING *';
    result = await query(q2, [hashedPassword, parseInt(id, 10)]);
    i += result.rowCount;
    max = +1;
  }
  if (i !== max) {
    console.error('Failed to update User');
  }
  console.log(result)
  return result.rows[0];
}

export async function getAllUsers(offset = 0, limit = 10) {
  const q = `
  SELECT username,email,admin FROM users ORDER BY id asc OFFSET $1 LIMIT $2
`;
  try {
    const result = await query(
      q, [offset, limit],
    );
    const total = await getUsersTotal();
    const items = result.rows;
    return [items, total];
  } catch (e) {
    console.error(e);
  }
  return null;
}

export async function createUser(req) {
  // Geymum hashað password!
  const { username, email, password } = req.body;
  const hashedPassword = await bcrypt.hash(password, 11);
  const q = `
    INSERT INTO
      users (username, password, email)
    VALUES ($1, $2, $3)
    RETURNING *
  `;

  try {
    const result = await query(q, [username, hashedPassword, email]);
    return result.rows[0];
  } catch (e) {
    console.error(e);
  }

  return null;
}
