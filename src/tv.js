import pg from 'pg';
import dotenv from 'dotenv';
import { uploadImg } from './cloudinary.js';

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

// name,number,airDate,overview,season,serie,serieId
export async function createEpisodes(episode) {
  const {
    serieId, name, airDate, season, overview, serie, number,
  } = episode;
  const d = Date.parse(airDate);
  const q = `
    INSERT INTO
      episode (serie_id,name,overview,air_date, season_id,number, serie)
    VALUES ($1, $2, $3, $4, $5, $6,$7)
    RETURNING *
  `;
  try {
    const result = await query(
      q, [serieId, name, overview, new Date(d), season, number, serie],
    );
    return result.rows[0];
  } catch (e) {
    console.error(e);
  }
  return null;
}

// name,number,airDate,overview,poster,serie,serieId
export async function createSeasons(series) {
  const {
    serieId, name, airDate, poster, overview, serie, number,
  } = series;
  let parsedDate = '';
  if (airDate.length > 0) {
    const d = Date.parse(airDate);
    parsedDate = new Date(d);
  }
  const q = `
    INSERT INTO
      seasons (serie_id,name,overview,air_date, poster,number, serie)
    VALUES ($1, $2, $3, $4, $5, $6,$7)
    RETURNING *
  `;
  try {
    const imgUrl = await uploadImg(`./data/img/${poster}`);
    const result = await query(
      q, [serieId, name, overview, parsedDate, imgUrl, number, serie],
    );
    return result.rows[0];
  } catch (e) {
    console.error(e);
  }
  return null;
}

export async function checkIfGenreExists(genre) {
  const q = `
  SELECT name FROM genres WHERE name = $1
`;
  try {
    const result = await query(
      q, [genre],
    );
    return result.rows[0].length !== 0;
  } catch (e) {
    console.error(e);
  }
  return null;
}

export async function addGenre(genre) {
  if (await checkIfGenreExists(genre)) return;
  const q = `
    INSERT INTO
      genres (name)
    VALUES ($1)
    RETURNING *
  `;
  try {
    const result = await query(
      q, [genre],
    );
    // eslint-disable-next-line consistent-return
    return result.rows[0];
  } catch (e) {
    console.error(e);
  }
}

export async function addGenresSeriesConnection(id, genre) {
  await addGenre(genre);
  const q = `
    INSERT INTO
      series_genres (series_id, genres_name)
    VALUES ($1, $2)
    RETURNING *
  `;
  try {
    const result = await query(
      q, [id, genre],
    );
    return result.rows[0];
  } catch (e) {
    console.error(e);
  }

  return null;
}

export async function createSeries(series) {
  const {
    id, name, tagline, description, airDate, inProduction, image, language, network, homepage,
  } = series;
  let parsedDate = '';
  if (airDate.length > 0) {
    const d = Date.parse(airDate);
    parsedDate = new Date(d);
  }

  const q = `
    INSERT INTO
      series (id,name,tagline,description,air_date, in_production, image,language,network,url)
    VALUES ($1, $2, $3, $4, $5, $6,$7 ,$8 ,$9, $10)
    RETURNING *
  `;
  try {
    const imgUrl = await uploadImg(`./data/img/${image}`);
    const result = await query(
      q, [id, name, tagline, description, parsedDate,
        inProduction, imgUrl, language, network, homepage],
    );
    return result.rows[0];
  } catch (e) {
    console.error(e);
  }

  return null;
}
