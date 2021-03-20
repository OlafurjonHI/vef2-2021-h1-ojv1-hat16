/* eslint-disable camelcase */
import express from 'express';
import { query, insert } from './db.js';

// The root of this router is /tv as defined in app.js
export const router = express.Router();

/**
 * Displays a page with TV shows and basic data.
 */
router.get('/', async (req, res) => {
  const q = 'SELECT * FROM episode';
  res.send(await query(q));
});

/**
 * TODO: Ensure admin is logged in
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
 *
 */
router.get('/:id?', async (req, res) => {
  const id = req.params;

});
