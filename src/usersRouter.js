import express from 'express';
import { body, validationResult } from 'express-validator';
import xss from 'xss';
import { createUser } from './users.js';

// The root of this router is /users as defined in app.js
export const router = express.Router();

/**
 *
 */
const validationMiddleware = [
  body('username')
    .isLength({ min: 1 })
    .withMessage('Nafn má ekki vera tómt'),
  body('username')
    .isLength({ max: 128 })
    .withMessage('Nafn má að hámarki vera 128 stafir'),
  body('email')
    .isLength({ min: 1 })
    .isEmail()
    .withMessage('Invalid Value'),
  body('comment')
    .isLength({ max: 400 })
    .withMessage('Athugasemd má að hámarki vera 400 stafir'),
];

// Viljum keyra sér og með validation, ver gegn „self XSS“
const xssSanitizationMiddleware = [
  body('name').customSanitizer((v) => xss(v)),
  body('nationalId').customSanitizer((v) => xss(v)),
  body('comment').customSanitizer((v) => xss(v)),
  body('anonymous').customSanitizer((v) => xss(v)),
];

const sanitizationMiddleware = [
  body('name').trim().escape(),
  body('nationalId').blacklist('-'),
];

async function validationCheck(req, res, next) {
  const validation = validationResult(req);
  console.log(validation);
  if (!validation.isEmpty()) {
    return res.send(validation.errors);
  }

  return next();
}

function catchErrors(fn) {
  return (req, res, next) => fn(req, res, next).catch(next);
}

router.get('/users/register',
  validationMiddleware,
  xssSanitizationMiddleware,
  validationCheck,
  sanitizationMiddleware,
  catchErrors(createUser));
