import express from 'express';

import { getGenres, addGenre } from './tv.js';
import { generateJson } from './helpers.js';

import { requireAuthentication, isAdmin } from './login.js';

export const router = express.Router();

/**
 * TODO
 */
router.get('/', async (req, res) => {
  const { limit = 10, offset = 0 } = req.query;
  const [items, total] = await getGenres(offset, limit);
  const { host } = req.headers;
  const { baseUrl } = req;
  res.json(generateJson(parseInt(limit, 10), parseInt(offset, 10), items, total, `${host}${baseUrl}`));
});

/**
   * TODO
   */
router.post('/', requireAuthentication, isAdmin, async (req, res) => {
  const { name } = req.body;
  const { limit = 10, offset = 0 } = req.query;
  const { host } = req.headers;
  const { baseUrl } = req;
  if (!name || name.length > 256) res.json({ error: 'name is required, max 256 characters' });
  await addGenre(name);
  const [items, total] = await getGenres(offset, limit);
  res.json(generateJson(parseInt(limit, 10), parseInt(offset, 10), items, total, `${host}${baseUrl}`));
});
