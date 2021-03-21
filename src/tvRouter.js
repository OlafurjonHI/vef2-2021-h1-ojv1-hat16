/* eslint-disable camelcase */
import express from 'express';
import multer from 'multer';

import {
  storage, uploadImg, uploadStream, upload,
} from './cloudinary.js';
import {
  getSeries, getSeriesById, getSeasonTotalBySerieId,
  getSeasonsBySerieId, getSeasonsBySerieIdAndSeason, getEpisodesBySerieIdAndSeason,
  insertSeries, updateSeries, getOnlySeriesById, deleteFromTable, createSeasons,
  getEpisodeBySeasonIdBySerieId, deleteSeasonByIdAndNumber, deleteEpisodeBySeasonAndSerie,
  insertEpisode, getSerieRatingByUserId, createSerieRatingForUser, getSerieStatusByUserId,
  createSerieStateForUser, getEpisodeTotalBySerieIdAndSeason, updateStateAndRatingForSerieAndUser,
} from './tv.js';
import {
  seasonsValidationMiddleware, catchErrors, validationCheck, rateValidationMiddleware,
  stateValidationMiddleware, isSeriesValid, isSeasonValid, isImageValid,
} from './validation.js';
import { requireAuthentication, isAdmin, getUserIdFromToken } from './login.js';
import { generateJson } from './helpers.js';
import { findByUsername } from './users.js';

// const storage = multer.memoryStorage();

const multerUploads = multer({ storage });

// Rótin á þessum router er '/tv' eins og skilgreint er í app.js
export const router = express.Router();

/**
 * Skilar síðum af sjónvarpsþáttum með grunnupplýsingum
 */
router.get('/', async (req, res) => {
  const { limit = 10, offset = 0 } = req.query;
  const [items, total] = await getSeries(offset, limit);
  const { host } = req.headers;
  const { baseUrl } = req;
  res.json(generateJson(parseInt(limit, 10), parseInt(offset, 10), items, total, `${host}${baseUrl}`));
});

/**
 * TODO: Græja upload á myndum
    requireAuthentication,
    isAdmin,
    isImageValid,
 */
router.post('/',
  requireAuthentication,
  isAdmin,
  seriesValidationMiddleware,
  catchErrors(validationCheck),
  superSanitizationMiddleware,
  async (req, res) => {
    const result = await insertSeries(req.body);
    res.json(result.rows);
  });

/**
 * TODO: Add avarage rating, rating count.
 *       Kemur villa í console þegar user er ekki loggaður inn, split notað á undefined.
 *
 * Displays a TV series with respective data
 */
router.get('/:id?',
  isSeriesValid,
  async (req, res) => {
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
router.patch('/:id?',
  isSeriesValid,
  requireAuthentication,
  isAdmin,
  async (req, res) => {
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
 * Eyðir sjónvarpsþátt, aðeins ef notandi er stjórnandi
 */
router.delete('/:id?',
  isSeriesValid,
  requireAuthentication,
  isAdmin,
  async (req, res) => {
    const { id } = req.params;
    await deleteFromTable('series_genres', 'series_id', id);
    await deleteFromTable('series', 'id', id);
    res.json({});
  });

/**
 * Skilar fylki af öllum seasons fyrir sjónvarpsþátt
 */
router.get('/:id/season/',
  isSeriesValid,
  async (req, res) => {
    const { id } = req.params;
    const { limit = 10, offset = 0 } = req.query;
    const { host } = req.headers;
    const { baseUrl } = req;
    const seasons = await getSeasonsBySerieId(id, offset, limit);
    const { total } = await getSeasonTotalBySerieId(id);
    res.json(generateJson(parseInt(limit, 10), parseInt(offset, 10), seasons, total, `${host}${baseUrl}`));
  });

/**
 * Býr til nýtt í season í sjónvarpþætti, aðeins ef notandi er stjórnandi
 */
router.post('/:id/season/',
  isSeriesValid,
  requireAuthentication,
  isAdmin,
  seasonsValidationMiddleware,
  catchErrors(validationCheck),
  superSanitizationMiddleware,
  async (req, res) => {
    const { id } = req.params;
    const season = await createSeasons(req.body, id);
    res.json(season);
  });

/**
 * Skilar stöku season fyrir þátt með grunnupplýsingum, fylki af þáttum
 * Niðurstaðan er viljandi öðruvísi en sýnidæmi til að bæta við paging virkni
 */
router.get('/:id/season/:seid?',
  isSeriesValid,
  isSeasonValid,
  async (req, res) => {
    const { id, seid } = req.params;
    const { limit = 10, offset = 0 } = req.query;
    const { host } = req.headers;
    const { baseUrl } = req;
    const total = await getEpisodeTotalBySerieIdAndSeason(id, seid);
    const season = await getSeasonsBySerieIdAndSeason(id, seid, offset, limit);
    const episodes = await getEpisodesBySerieIdAndSeason(id, seid, offset, limit);
    season.episodes = episodes;

    return res.json(generateJson(parseInt(limit, 10), parseInt(offset, 10), season, total, `${host}${baseUrl}`));
  });

/**
 * Eyðir season, aðeins ef notandi er stjórnandi
 */
router.delete('/:id/season/:seasonId?',
  isSeriesValid,
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
 */
router.post('/:id/season/:seid/episode/',
  isSeriesValid,
  isSeasonValid,
  requireAuthentication,
  isAdmin,
  superSanitizationMiddleware,
  async (req, res) => {
    const { id, seid } = req.params;
    req.body.serie_id = id;
    req.body.season = seid;
    // console.log(req.body);
    const result = await insertEpisode(req.body, id, seid);
    res.json(result.rows[0]);
  });

/**
 * Skilar upplýsingum um þátt
 */
router.get('/:id/season/:seid/episode/:eid',
  isSeriesValid,
  isSeasonValid,
  async (req, res) => {
    const episode = await getEpisodeBySeasonIdBySerieId(req.params);
    if (!episode) res.status(404).json({ error: 'episode not found' });
    res.json(episode);
  });

/**
 * Eyðir þætti, aðeins ef notandi er stjórnandi
 */
router.delete('/:id/season/:seid/episode/:eid',
  requireAuthentication,
  isAdmin,
  async (req, res) => {
    const deleted = await (deleteEpisodeBySeasonAndSerie(req.params));
    if (deleted === 0) res.status(404).json({ error: 'episode not found' });
    res.json({});
  });

/**
 * Skráir einkunn innskráðs notanda á sjónvarpsþætti, aðeins fyrir innskráða notendur
 */
router.post('/:id/rate', requireAuthentication, rateValidationMiddleware, catchErrors(validationCheck), superSanitizationMiddleware, async (req, res) => {
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
    await updateUserUpdatedTimeStamp(user.id);
    res.json(row);
  }
});

/**
 * Skráir stöðu innskráðs notanda á sjónvarpsþætti, aðeins fyrir innskráða notendur
 */
router.post('/:id/state', requireAuthentication, stateValidationMiddleware, catchErrors(validationCheck), superSanitizationMiddleware,async (req, res) => {
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
    await updateUserUpdatedTimeStamp(user.id);
    res.json(row);
  }
});

/**
 * Uppfærir stöðu innskráðs notanda á sjónvarpsþætti
 */
router.patch('/:id/state', requireAuthentication, stateValidationMiddleware, catchErrors(validationCheck), async (req, res) => {
  const { id } = req.params;
  const { state } = req.body;
  const authorization = req.headers.authorization.split(' ')[1];
  const user = await findByUsername(getUserIdFromToken(authorization));
  const ratingExists = await getSerieRatingByUserId(id, user.id);
  const row = await updateStateAndRatingForSerieAndUser(id, user.id, ratingExists.rating, state);
  await updateUserUpdatedTimeStamp(user.id);
  res.json(row);
});

/**
 * Uppfærir einkunn innskráðs notanda á sjónvarpsþætti
 */
router.patch('/:id/rate', requireAuthentication, rateValidationMiddleware, catchErrors(validationCheck), async (req, res) => {
  const { id } = req.params;
  const { rating } = req.body;
  const authorization = req.headers.authorization.split(' ')[1];
  const user = await findByUsername(getUserIdFromToken(authorization));
  const stateExists = await getSerieStatusByUserId(id, user.id);
  const row = await updateStateAndRatingForSerieAndUser(id, user.id, rating,
    stateExists.status, false);
  await updateUserUpdatedTimeStamp(user.id);
  res.json(row);
});

/**
 * Eyðir stöðu innskráðs notanda á sjónvarpsþætti
 */
router.delete('/:id/state', requireAuthentication, async (req, res) => {
  const { id } = req.params;
  const authorization = req.headers.authorization.split(' ')[1];
  const user = await findByUsername(getUserIdFromToken(authorization));
  const ratingExists = await getSerieRatingByUserId(id, user.id);
  const row = await updateStateAndRatingForSerieAndUser(id, user.id,
    ratingExists.rating, undefined);
  await updateUserUpdatedTimeStamp(user.id);
  res.json(row);
});

/**
 * Eyðir einkunn innskráðs notanda á sjónvarpsþætti
 */
router.delete('/:id/rate', requireAuthentication, async (req, res) => {
  const { id } = req.params;
  const authorization = req.headers.authorization.split(' ')[1];
  const user = await findByUsername(getUserIdFromToken(authorization));
  const stateExists = await getSerieStatusByUserId(id, user.id);
  const row = await updateStateAndRatingForSerieAndUser(id, user.id, 0,
    stateExists.status, false);
  await updateUserUpdatedTimeStamp(user.id);

  res.json(row);
});
