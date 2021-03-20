/* eslint-disable camelcase */
import express, { json } from 'express';
import {
  getSeries, getSeriesById, getSeriesTotal, getSeasonTotalBySerieId, getSeasonsBySerieId,
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
router.post('/', async (req, res) => {
  const {
    name, air_date, in_production, tagline, image, description, language, network, url,
  } = req.body;

  const values = [
    name, air_date, in_production, tagline,
    image, description, language, network, url,
  ];

  const q = `
    INSERT INTO series
      (name, air_date, in_production, tagline,
      image, description, language, network, url)
    VALUES
      ($1, $2, $3, $4, $5, $6, $7, $8, $9);
    `;

  query(q, values);
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
 * TODO
 */
router.get('/tv/:id/season/:id');

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
