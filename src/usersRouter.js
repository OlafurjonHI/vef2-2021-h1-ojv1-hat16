import express from 'express';
import { Strategy } from 'passport-local';
import passport, { strat, requireAuthentication, loginUser, jwtOptions} from './login.js';

import { createUser, getAllUsers } from './users.js';
import { generateJson } from './helpers.js';
import {
  validationMiddleware, xssSanitizationMiddleware, validationCheck,
  sanitizationMiddleware, loginValidationMiddleware,
} from './validation.js';

// The root of this router is /users as defined in app.js
export const router = express.Router();
passport.use(new Strategy(jwtOptions, strat));
router.use(passport.initialize());

function catchErrors(fn) {
  return (req, res, next) => fn(req, res, next).catch(next);
}

// TO IS ADMIN
router.get('/', requireAuthentication, async (req, res) => {
  const { limit = 10, offset = 0 } = req.query;
  const [items, total] = await getAllUsers(offset, limit);
  const { host } = req.headers;
  const { baseUrl } = req;
  res.json(generateJson(parseInt(limit, 10), parseInt(offset, 10), items, total, `${host}${baseUrl}`));
});

router.post('/login',
  loginValidationMiddleware,
  xssSanitizationMiddleware,
  catchErrors(validationCheck),
  sanitizationMiddleware,
  loginUser);

router.post('/register',
  validationMiddleware,
  xssSanitizationMiddleware,
  catchErrors(validationCheck),
  sanitizationMiddleware,
  catchErrors(createUser));
