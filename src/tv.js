/* eslint-disable camelcase */
import { uploadImg } from './cloudinary.js';
import { query } from './db.js';

export async function getTotalRatingCountsForSerie(serieId) {
  const q = `
    SELECT count(*) as total FROM users_series WHERE series_id = $1;
  `;
  const result = await query(q, [serieId]);
  return result.rows[0];
}

export async function getAvarageSerieRating(serieId) {
  const total = await getTotalRatingCountsForSerie(serieId);
  if (total === 0) return 0;
  const q = `
  SELECT avg(rating) as total FROM users_series WHERE series_id = $1;
`;
  const result = await query(q, [serieId]);
  const avgRating = (result.rows[0].total) ? result.rows[0].total : 0;
  return [avgRating, total];
}

export async function getSeriesTotal() {
  const q = `
  SELECT count(*) as total FROM series
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

export async function getGenresTotal() {
  const q = `
  SELECT count(*) as total FROM genres
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
export async function getSeries(offset = 0, limit = 10) {
  const q = `
  SELECT id,name,air_date,in_production,tagline,image,description,language,network,url FROM series ORDER BY id asc OFFSET $1 LIMIT $2
`;
  try {
    const result = await query(
      q, [offset, limit],
    );
    const items = result.rows;
    const total = await getSeriesTotal();
    return [items, total.total];
  } catch (e) {
    console.error(e);
  }
  return null;
}

export async function getSerieRatingByUserId(serieId, userId) {
  const total = await getTotalRatingCountsForSerie(serieId);
  if (total === 0) return 0;
  const q = `
  SELECT rating FROM users_series WHERE series_id = $1 AND user_id = $2
`;
  const result = await query(q, [serieId, userId]);

  return result.rows[0];
}
export async function getSerieStatusByUserId(serieId, userId) {
  const total = await getTotalRatingCountsForSerie(serieId);
  if (total === 0) return 0;
  const q = `
  SELECT status FROM users_series WHERE series_id = $1 AND user_id = $2
`;
  const result = await query(q, [serieId, userId]);

  return result.rows[0];
}

export async function getSeriesById(id, userId) {
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
  const [avgRating, total] = await getAvarageSerieRating(id);
  serie.avaragerating = avgRating;
  serie.ratingCount = parseInt(total.total, 10);
  if (userId) {
    const userRating = await getSerieRatingByUserId(id, userId);
    serie.rating = (userRating) || 'unrated';
    const userStatus = await getSerieRatingByUserId(id, userId);
    serie.status = userStatus;
  }
  serie.genres = genres;
  serie.seasons = seasons;
  return serie;
}

export async function getOnlySeriesById(id) {
  const q = 'SELECT id,name,air_date,in_production,tagline,image,description,language,network,url FROM series where id = $1';
  const result = await query(q, [id]);
  const serie = result.rows[0];
  return serie;
}

export async function getSeasonTotalBySerieId(serieId) {
  const q = `
    SELECT count(*) as total FROM seasons WHERE serie_id = $1;
  `;
  try {
    const result = await query(
      q, [serieId],
    );
    return result.rows[0];
  } catch (e) {
    console.error(e);
  }
  return null;
}

export async function getSeasonsBySerieId(serieId, offset = 0, limit = 10) {
  const q = 'SELECT id,name,number,air_date,overview,poster FROM seasons where serie_id = $1 ORDER BY id asc OFFSET $2 LIMIT $3';
  const result = await query(q, [serieId, offset, limit]);
  const seasons = result.rows;

  return seasons;
}

export async function getSeasonsBySerieIdAndSeason(serieId, seasonNumber, offset = 0, limit = 10) {
  const q = 'SELECT id, name, number, air_date, overview, poster FROM seasons WHERE serie_id = $1 AND number = $2 OFFSET $3 LIMIT $4;';
  const result = await query(q, [serieId, seasonNumber, offset, limit]);

  return result;
}

export async function getEpisodesBySerieIdAndSeason(serieId, seasonNumber, offset = 0, limit = 10) {
  const q = 'SELECT name, number, air_date, overview FROM episode WHERE serie_id = $1 AND season = $2 ORDER BY number OFFSET $3 LIMIT $4;';
  const result = await query(q, [serieId, seasonNumber, offset, limit]);

  return result;
}

export async function getEpisodeBySeasonIdBySerieId(data) {
  const { sid, seid, eid } = data;
  const q = 'SELECT name,number,air_date, overview,serie_id,season,serie from episode WHERE serie_id = $1 AND season = $2 AND number = $3;';
  const result = await query(q, [sid, seid, eid]);
  return result.rows[0];
}

export async function getGenres(offset = 0, limit = 10) {
  const q = 'SELECT name FROM genres OFFSET $1 LIMIT $2;';
  const total = await getSeriesTotal();
  const result = await query(q, [offset, limit]);
  const items = result.rows;
  return [items, total];
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
export async function createSeasons(series, id = null) {
  const {
    serieId = id, name, airDate, poster, overview, serie, number,
  } = series;
  let parsedDate = null;
  if (airDate && airDate.length > 0) {
    const d = Date.parse(airDate);
    parsedDate = new Date(d);
  }
  let imgUrl = 'FAKEPATH';
  if (!poster == null) {
    imgUrl = await uploadImg(`./data/img/${poster}`);
  } else {
    imgUrl = 'FAKEPATH';
  }
  const q = `
    INSERT INTO
      seasons (serie_id,name,overview,air_date, poster,number, serie)
    VALUES ($1, $2, $3, $4, $5, $6,$7)
    RETURNING *
  `;
  try {
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

export async function insertSeries(series) {
  const {
    name, airDate, inProduction, tagline, image, description, language, network, url,
  } = series;

  // Þurfum að finna út úr því hvernig við ætlum að höndla myndir
  // TODO ákveða hvernig við höndlum myndir

  let imgUrl;
  try {
    // Fyrir testing reasons notum við static test mynd
    const testImage = './test-image.png';
    imgUrl = await uploadImg(testImage);

    // const imgUrl = await uploadImg(`./data/img/${image}`);
  } catch (e) {
    console.error(e);
  }

  const q = `INSERT INTO
    series (name, tagline, description, air_date,
      in_production, image, language, network, url)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
    RETURNING *;
    `;

  const result = await query(
    q, [name, tagline, description, airDate, inProduction,
      imgUrl, language, network, url],
  );

  return result;
}

export async function insertEpisode(episode) {
  const {
    serie_id, name, air_date, season, overview, serie, number,
  } = episode;

  const q = `
    INSERT INTO episode
      (serie_id, name, air_date, season, overview, serie, number)
    VALUES ($1, $2, $3, $4, $5, $6, $7)
    RETURNING *;`;

  const result = await query(q, [serie_id, name, air_date, season, overview, serie, number]);
  return result;
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

export async function updateSeries(column, value, id) {
  const q = `UPDATE series SET ${column} = $1 WHERE id = $2 RETURNING *`;
  // const q = 'UPDATE series SET name = $2 WHERE id = $3';
  const result = await query(q, [value.toString(), parseInt(id, 10)]);
  return result;
}

// export async function deleteFromSeriesGenre

export async function deleteFromTable(table, column, id) {
  const q = `DELETE FROM ${table} WHERE ${column} = $1;`;
  const result = query(q, [id]);

  return result;
}

export async function deleteSeasonByIdAndNumber(seriesId, seasonNumber) {
  const q = 'DELETE FROM seasons WHERE serie_id = $1 AND number = $2;';
  const result = await query(q, [seriesId, seasonNumber]);
  return result.rowCount;
}

export async function deleteEpisodeBySeasonAndSerie(data) {
  const { sid, seid, eid } = data;
  const q = 'DELETE FROM episode WHERE serie_id = $1 AND season = $2 AND number = $3;';
  const result = await query(q, [parseInt(sid, 10), parseInt(seid, 10), parseInt(eid, 10)]);
  return result.rowCount;
}

export async function createSerieRatingForUser(rating, uid, sid) {
  const q = `
    INSERT INTO users_series
      (series_id, user_id, rating)
    VALUES ($1, $2, $3)
    RETURNING series_id, user_id, rating;`;

  const result = await query(q, [sid, uid, rating]);
  return result.rows[0];
}
export async function createSerieStateForUser(state, uid, sid) {
  const q = `
    INSERT INTO users_series
      (series_id, user_id, status)
    VALUES ($1, $2, $3)
    RETURNING series_id, user_id, status;`;

  const result = await query(q, [sid, uid, state]);
  return result.rows[0];
}

