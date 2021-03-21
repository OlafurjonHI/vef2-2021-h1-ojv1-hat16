/* eslint-disable camelcase */
import express from 'express';
import e from 'express';
import {
  getSeries, getSeriesById, getSeasonTotalBySerieId,
  getSeasonsBySerieId, getSeasonsBySerieIdAndSeason, getEpisodesBySerieIdAndSeason,
  insertSeries, updateSeries, getOnlySeriesById, deleteFromTable, createSeasons,
  getEpisodeBySeasonIdBySerieId, deleteSeasonByIdAndNumber, deleteEpisodeBySeasonAndSerie,
  insertEpisode,
  getSerieRatingByUserId,
  createSerieRatingForUser,
  getSerieStatusByUserId,
  createSerieStateForUser,
  getEpisodeTotalBySerieIdAndSeason,
  updateStateAndRatingForSerieAndUser,
} from './tv.js';

import {
  seasonsValidationMiddleware, catchErrors, validationCheck, rateValidationMiddleware, stateValidationMiddleware,
} from './validation.js';
import { requireAuthentication, isAdmin, getUserIdFromToken } from './login.js';
import { generateJson } from './helpers.js';
import { findByUsername } from './users.js';

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
  let userId = null;
  try {
    const authorization = req.headers.authorization.split(' ')[1];
    const user = await findByUsername(getUserIdFromToken(authorization));
    userId = user.id;
  } catch (e) {
    console.error(e);
  }
  const jsonObject = await getSeriesById(id, userId);

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
router.post('/:id/season/', requireAuthentication, isAdmin,
  seasonsValidationMiddleware,
  catchErrors(validationCheck),
  async (req, res) => {
    const { id } = req.params;
    const season = await createSeasons(req.body, id);
    res.json(season);
  });

/**
 * TODO: Villumeðhöndlun ef seria eða season er ekki til
 *       Græja paging með t.d. makeJson hjálparfallinu
 *
 * Skilar stöku season fyrir þátt með grunnupplýsingum, fylki af þáttum
 */
router.get('/:id/season/:seasonId?',
  seasonsValidationMiddleware,
  async (req, res) => {
    const { id, seasonId } = req.params;
    const { limit = 10, offset = 0 } = req.query;
    const { host } = req.headers;
    const { baseUrl } = req;
    let result = await getSeasonsBySerieIdAndSeason(id, seasonId, offset, limit);
    if (!result) return res.status(404).json({ error: 'Series not found' });
    const season = result;
    result = await getEpisodesBySerieIdAndSeason(id, seasonId, offset, limit);
    const episodes = result;
    if (!episodes) return res.status(404).json({ error: 'season not found' });
    const total = await getEpisodeTotalBySerieIdAndSeason(id, seasonId);
    season.episodes = episodes;
    res.json(generateJson(parseInt(limit, 10), parseInt(offset, 10), season, total, `${host}${baseUrl}`));
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
    if (result === 0) res.status(404).json({ error: 'episode not found' });

    res.json({});
  });

/**
 * Býr til nýjan þátt í season, aðeins ef notandi er stjórnandi
 *
 */
router.post('/:id/season/:seasonId/episode/',
  requireAuthentication,
  isAdmin,
  async (req, res) => {
    const { id, seasonId } = req.params;
    req.body.serie_id = id;
    req.body.season = seasonId;
    // console.log(req.body);
    const result = await insertEpisode(req.body, id, seasonId);
    res.json(result.rows[0]);
  });

router.get('/:sid/season/:seid/episode/:eid', async (req, res) => {
  const episode = await getEpisodeBySeasonIdBySerieId(req.params);
  if (!episode) res.status(404).json({ error: 'episode not found' });
  res.json(episode);
});

router.delete('/:sid/season/:seid/episode/:eid',
  requireAuthentication,
  isAdmin,
  async (req, res) => {
    const deleted = await (deleteEpisodeBySeasonAndSerie(req.params));
    if (deleted === 0) res.status(404).json({ error: 'episode not found' });
    res.json({});
  });

router.post('/:id/rate', requireAuthentication, rateValidationMiddleware, catchErrors(validationCheck), async (req, res) => {
  const { id } = req.params;
  const { rating } = req.body;
  const authorization = req.headers.authorization.split(' ')[1];
  const user = await findByUsername(getUserIdFromToken(authorization));
  const ratingExists = await getSerieRatingByUserId(id, user.id);
  const stateExists = await getSerieStatusByUserId(id, user.id);
  if (ratingExists && ratingExists.rating && stateExists && stateExists.status) res.json({ errors: { value: `${rating}`, param: 'rating', message: 'value already exists, use PATCH to update' } });
  else if (ratingExists && ratingExists.rating) res.json({ errors: { value: `${rating}`, param: 'rating', message: 'value already exists, use PATCH to update' } });
  else if (stateExists) {
    const row = await updateStateAndRatingForSerieAndUser(id, user.id, rating,
      stateExists.status, false);
    res.json(row);
  } else {
    const row = await createSerieRatingForUser(rating, user.id, id);
    res.json(row);
  }
});

router.post('/:id/state', requireAuthentication, stateValidationMiddleware, catchErrors(validationCheck), async (req, res) => {
  const { id } = req.params;
  const { state } = req.body;
  const authorization = req.headers.authorization.split(' ')[1];
  const user = await findByUsername(getUserIdFromToken(authorization));
  const ratingExists = await getSerieRatingByUserId(id, user.id);
  const stateExists = await getSerieStatusByUserId(id, user.id);
  if (ratingExists && ratingExists.rating && stateExists && stateExists.status) res.json({ errors: { value: `${state}`, param: 'state', message: 'value already exists, use PATCH to update' } });
  else if (stateExists && stateExists.status != null) res.json({ errors: { value: `${state}`, param: 'state', message: 'value already exists, use PATCH to update' } });
  else if (ratingExists) {
    const row = await updateStateAndRatingForSerieAndUser(id, user.id, ratingExists.rating, state);
    res.json(row);
  } else {
    const row = await createSerieStateForUser(state, user.id, id);
    res.json(row);
  }
});

router.patch('/:id/state', requireAuthentication, stateValidationMiddleware, catchErrors(validationCheck), async (req, res) => {
  const { id } = req.params;
  const { state } = req.body;
  const authorization = req.headers.authorization.split(' ')[1];
  const user = await findByUsername(getUserIdFromToken(authorization));
  const ratingExists = await getSerieRatingByUserId(id, user.id);
  const row = await updateStateAndRatingForSerieAndUser(id, user.id, ratingExists.rating, state);
  res.json(row);
});

router.patch('/:id/rate', requireAuthentication, rateValidationMiddleware, catchErrors(validationCheck), async (req, res) => {
  const { id } = req.params;
  const { rating } = req.body;
  const authorization = req.headers.authorization.split(' ')[1];
  const user = await findByUsername(getUserIdFromToken(authorization));
  const stateExists = await getSerieStatusByUserId(id, user.id);
  const row = await updateStateAndRatingForSerieAndUser(id, user.id, rating,
    stateExists.status, false);
  res.json(row);
});

router.delete('/:id/state', requireAuthentication, async (req, res) => {
  const { id } = req.params;
  const authorization = req.headers.authorization.split(' ')[1];
  const user = await findByUsername(getUserIdFromToken(authorization));
  const ratingExists = await getSerieRatingByUserId(id, user.id);
  const row = await updateStateAndRatingForSerieAndUser(id, user.id, ratingExists.rating, '');
  res.json(row);
});

router.delete('/:id/rate', requireAuthentication, async (req, res) => {
  const { id } = req.params;
  const authorization = req.headers.authorization.split(' ')[1];
  const user = await findByUsername(getUserIdFromToken(authorization));
  const stateExists = await getSerieStatusByUserId(id, user.id);
  const row = await updateStateAndRatingForSerieAndUser(id, user.id, 0,
    stateExists.status, false);
  res.json(row);
});
