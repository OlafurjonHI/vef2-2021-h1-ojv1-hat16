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

export async function createSeries(series) {
  const {
    id, name, tagline, description, airDate, inProduction, image, language, network, url,
  } = series;
  const d = Date.parse(airDate);
  const q = `
    INSERT INTO
      series (id,name,tagline,description,air_date, in_production, image,language,network,url)
    VALUES ($1, $2, $3, $4, $5, $6,$7 ,$8 ,$9, $10)
    RETURNING *
  `;

  try {
    const result = await query(
      q, [id, name, tagline, description, new Date(d), inProduction, image, language, network, url],
    );
    return result.rows[0];
  } catch (e) {
    console.error(e);
  }

  return null;
}
