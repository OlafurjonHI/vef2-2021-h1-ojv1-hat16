import { uploadImg } from './cloudinary.js';
import { query } from './db.js';

export async function getSeries(offset = 0, limit = 10) {
  const q = `
  SELECT id,name,air_date,in_production,tagline,image,description,language,network,url FROM series ORDER BY id asc OFFSET $1 LIMIT $2 
`;
  try {
    let  result = await query(
      q, [offset, limit],
    );
    const items = result.rows;
    const total = await getSeriesTotal();
    return [items,total.total];
  } catch (e) {
    console.erorr(e);
  }
  return null;
}
export async function getSeriesTotal() {
  const q = `
  SELECT count(*) as total FROM series
`;
  try {
    let  result = await query(
      q, [],
    );
    return result.rows[0];
  } catch (e) {
    console.error(e);
  }
  return null;
}


export async function getSeriesById(id) {
  const q = 'SELECT id,name,air_date,in_production,tagline,image,description,language,network,url FROM series where id = $1';
  let result = await query(q, [id]);
  const serie = result.rows[0];
  // TODO BÆTA INN RATING
  const q2 = 'SELECT genres_name AS name FROM series_genres where series_id = $1';
  result = await query(q2, [id]);
  const genres = result.rows;

  const q3 = 'SELECT name,number,air_date,overview,poster FROM seasons where serie_id = $1';
  result = await query(q3, [id]);
  const seasons = result.rows;

  serie.genres = genres;
  serie.seasons = seasons;
  return serie;
}

// name,number,airDate,overview,season,serie,serieId
export async function createEpisodes(episode) {
  const {
    serieId, name, airDate, season, overview, serie, number,
  } = episode;
  let parsedDate = null;
  if (airDate.length > 0) {
    const d = Date.parse(airDate);
    parsedDate = new Date(d);
  }
  const q = `
    INSERT INTO
      episode (serie_id,name,overview,air_date, season,number, serie)
    VALUES ($1, $2, $3, $4, $5, $6,$7)
    RETURNING *
  `;
  try {
    const result = await query(
      q, [serieId, name, overview, parsedDate, season, number, serie],
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
  let parsedDate = null;
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
  let parsedDate = null;
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
