/* eslint-disable camelcase */
import express, { json } from 'express';
import {
  getSeries, getSeriesById, getSeriesTotal, getSeasonTotalBySerieId,
  getSeasonsBySerieId, getSeasonsBySerieIdAndSeason, getEpisodesBySerieIdAndSeason,
} from './tv.js';
import { generateJson } from './helpers.js';

// The root of this router is /tv as defined in app.js
export const router = express.Router();

/**
 * Displays a page with TV shows and basic data.
 */
router.get('/', async (req, res) => {
  const { limit = 10, offset = 0 } = req.query;
  const [items, total] = await getSeries(offset, limit);
  const { host } = req.headers;
  const { baseUrl } = req;
  res.json(generateJson(parseInt(limit, 10), parseInt(offset, 10), items, total, `${host}${baseUrl}`));
});

/**
 * TODO: Ensure admin is logged in
 *       Nota custom fall í tv.js í stað kalls á query hér
 *
 * Enables admin users to create new TV shows
 */
/**
  {
    "name": "Testname",
    "air_date": "2021-03-20T19:35:44.477Z",
    "in_production": true,
    "tagline": "This is a testing tagline",
    "image": "https://www.erkomideldgos.is/",
    "description": "This is a very descriptive test",
    "language": "en",
    "network": "network test",
    "url": "fake url for a test"
  }
 */
router.post('/', async (req, res) => {
  const {
    id, name, air_date, in_production, tagline, image, description, language, network, url,
  } = req.body;

  const values = [
    id, name, air_date, in_production, tagline,
    image, description, language, network, url,
  ];
  console.log(values);
  console.log(req.body);
  res.send({ response: 'thanks' });

/*   const q = `
    INSERT INTO series
      (id, name, air_date, in_production, tagline,
      image, description, language, network, url)
    VALUES
      ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);
    `;
  query(q, values); */
});

/**
 * TODO: Add avarage rating, rating count.
 *
 * Displays a TV series with respective data
 */
router.get('/:id?', async (req, res) => {
  const { id } = req.params;
  const jsonObject = await getSeriesById(id);
  res.json(jsonObject);
});

/**
 * TODO
 */
router.patch('/:id?');

/**
 * TODO
 */
router.delete('/:id?');

/**
 * Displays seasons of a series with respective data
 */
router.get('/:id/season/', async (req, res) => {
  const { id } = req.params;
  const { limit = 10, offset = 0 } = req.query;
  const { host } = req.headers;
  const { baseUrl } = req;
  const seasons = await getSeasonsBySerieId(id, offset, limit);
  const { total } = await getSeasonTotalBySerieId(id);
  res.json(generateJson(parseInt(limit, 10), parseInt(offset, 10), seasons, total, `${host}${baseUrl}`));
});

/**
 * TODO
 */
router.post('/:id/season/');

/**
 * TODO: Remove "serie_id" og serie í svari
 *
 * Skilar stöku season fyrir þátt með grunnupplýsingum, fylki af þáttum
 * Sýnilausn inniheldur ekki paging.
 * :id = seriesId
 * :seasonId = season í serie :id
 */
router.get('/:id/season/:seasonId?', async (req, res) => {
  const { id, seasonId } = req.params;
  let result = await getSeasonsBySerieIdAndSeason(id, seasonId);
  const season = result.rows[0];
  result = await getEpisodesBySerieIdAndSeason(id, seasonId);
  const episodes = result.rows;
  season.episodes = episodes;
  res.json(season);
});

/**
 * TODO
 */
router.delete('/tv/:id/season/:id');

/**
 * TODO
 */
router.post('/tv/:id/season/:id/episode/');

/**
 * TODO
 */
router.get('/tv/:id/season/:id/episode/:id');

/**
 * TODO
 */
router.delete('/tv/:id/season/:id/episode/:id');

/**
 * TODO
 */
router.get('/genres');

/**
 * TODO
 */
router.post('/genres');
