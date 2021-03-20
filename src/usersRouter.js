import express from 'express';
import { query } from './db.js';

// The root of this router is /users as defined in app.js
export const router = express.Router();

/**
 *
 */
router.get('/');
