import express from 'express';
import { Strategy } from 'passport-local';
import passport, { strat } from './login.js';

import { createUser, getAllUsers } from './users.js';
import { generateJson } from './helpers.js';
import {
  validationMiddleware, xssSanitizationMiddleware, validationCheck, sanitizationMiddleware,
} from './validation.js';

// The root of this router is /users as defined in app.js
export const router = express.Router();
passport.use(new Strategy(strat));
router.use(passport.initialize());
router.use(passport.session());
router.use((req, res, next) => {
  if (req.isAuthenticated()) {
    // getum núna notað user í viewum
    res.locals.user = req.user;
  } else {
    res.locals.user = null;
  }

  next();
});
export function ensureLoggedIn(req, res, next) {
  if (req.isAuthenticated()) {
    return next();
  }
  const error = {};
  error.error = 'invalid token';
  return res.json(error);
}

export function ensureAdmin(req, res, next) {
  if (req.isAuthenticated() && res.locals.user.admin) {
    return next();
  }

  return res.send('Must be admin');
}

function catchErrors(fn) {
  return (req, res, next) => fn(req, res, next).catch(next);
}

// TO IS ADMIN
router.get('/', ensureAdmin, async (req, res) => {
  const { limit = 10, offset = 0 } = req.query;
  const [items, total] = await getAllUsers(offset, limit);
  const { host } = req.headers;
  const { baseUrl } = req;
  res.json(generateJson(parseInt(limit, 10), parseInt(offset, 10), items, total, `${host}${baseUrl}`));
});

router.post('/register',
  validationMiddleware,
  xssSanitizationMiddleware,
  catchErrors(validationCheck),
  sanitizationMiddleware,
  catchErrors(createUser));