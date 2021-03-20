import express from 'express';
import { body, validationResult } from 'express-validator';
import xss from 'xss';
import { createUser, getAllUsers } from './users.js';
import { generateJson } from './helpers.js';

// The root of this router is /users as defined in app.js
export const router = express.Router();

/**
 *
 */
const validationMiddleware = [
  body('username')
    .isLength({ min: 1,max: 256 })
    .withMessage('username is required, max 256 characters'),
  body('email')
    .isEmail()
    .withMessage('Invalid Value'),
  body('email')
    .isLength({ min: 1, max: 256})
    .withMessage('email is required, max 256 characters'),
  body('password')
    .isLength({ min: 10, max: 256})
    .withMessage('password is required, min 10 characters, max 256 characters'),
];

// Viljum keyra sér og með validation, ver gegn „self XSS“
const xssSanitizationMiddleware = [
  body('username').customSanitizer((v) => xss(v)),
  body('email').customSanitizer((v) => xss(v)),
];

const sanitizationMiddleware = [
  body('username').trim().escape(),
];

async function validationCheck(req, res, next) {
  const validation = validationResult(req);
  if (!validation.isEmpty()) {
    return res.send(validation.errors);
  }

  return next();
}

function catchErrors(fn) {
  return (req, res, next) => fn(req, res, next).catch(next);
}

router.get('/', async (req, res) => {
  const { limit = 10, offset = 0 } = req.query;
  const [items,total] = await getAllUsers(offset, limit);
  const { host } = req.headers;
  const { baseUrl } = req;
  res.json(generateJson(parseInt(limit, 10), parseInt(offset, 10), items,total, `${host}${baseUrl}`));
});

router.post('/register',
validationMiddleware,
xssSanitizationMiddleware,
catchErrors(validationCheck),
sanitizationMiddleware,
catchErrors(createUser));
  