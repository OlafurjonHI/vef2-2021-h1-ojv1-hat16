/* eslint-disable camelcase */
import express from 'express';
import {
  getSeries, getSeriesById, getSeasonTotalBySerieId,
  getSeasonsBySerieId, getSeasonsBySerieIdAndSeason, getEpisodesBySerieIdAndSeason,
  insertSeries, updateSeries, getOnlySeriesById, deleteFromTable, deleteSeasonByIdAndNumber,
  createSeasons,
} from './tv.js';

import { seasonsValidationMiddleware, catchErrors, validationCheck } from './validation.js';
import { requireAuthentication, isAdmin } from './login.js';
import { generateJson } from './helpers.js';

// The root of this router is /tv as defined in app.js
export const router = express.Router();

/**
 * Displays a page with TV shows and basic data.
 */
router.get('/', requireAuthentication, isAdmin, async (req, res) => {
  const { limit = 10, offset = 0 } = req.query;
  const [items, total] = await getSeries(offset, limit);
  const { host } = req.headers;
  const { baseUrl } = req;
  res.json(generateJson(parseInt(limit, 10), parseInt(offset, 10), items, total, `${host}${baseUrl}`));
});

/**
 * TODO: Ensure admin is logged in
 *       Nota custom fall í tv.js í stað kalls á query hér
 *       Græja upload á myndum
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
router.post('/', requireAuthentication, isAdmin, async (req, res) => {
  const result = await insertSeries(req.body);
  res.json(result.rows);

  // res.send({ response: 'thanks mather, for my life' });
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
 * Uppfærir sjónvarpsþátt, reit fyrir reit, aðeins ef notandi er stjórnandi
 */
router.patch('/:id?', requireAuthentication, isAdmin, async (req, res) => {
  const { id } = req.params;
  Object.keys(req.body).forEach(async (key) => {
    await updateSeries(key, req.body[key], id);
  });
  const result = await getOnlySeriesById(id);
  res.send(result);
});

/**
 * TODO: Birta rétt JSON þegar ekki er neitt til að eyða.
 *
 * eyðir sjónvarpsþátt, aðeins ef notandi er stjórnandi
 */
router.delete('/:id?', requireAuthentication, isAdmin, async (req, res) => {
  const { id } = req.params;
  await deleteFromTable('series_genres', 'series_id', id);
  await deleteFromTable('series', 'id', id);
  res.json({});
});

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
// serieId, name, airDate, poster, overview, serie, number,
router.post('/:id/season/',
  seasonsValidationMiddleware,
  catchErrors(validationCheck),
  async (req, res) => {
    const { id } = req.params;
    const season = await createSeasons(req.body, id);
    res.json(season);
  });

/**
 * TODO: Villumeðhöndlun ef seria eða season er ekki til
 *
 * Skilar stöku season fyrir þátt með grunnupplýsingum, fylki af þáttum
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
 * Eyðir season, aðeins ef notandi er stjórnandi
 */
router.delete('/:id/season/:seasonId?',
  requireAuthentication,
  isAdmin,
  async (req, res) => {
    const { id, seasonId } = req.params;
    const result = await deleteSeasonByIdAndNumber(id, seasonId);
    res.json(result);
});

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
