import { body, validationResult } from 'express-validator';
import xss from 'xss';
import { checkIfSeasonExistsBySerieIdAndSeasonNumber, checkIfSeriesExistsById } from './tv.js';

export const validationMiddleware = [
  body('username')
    .isLength({ min: 1, max: 256 })
    .withMessage('username is required, max 256 characters'),
  body('email')
    .isEmail()
    .withMessage('Invalid Value'),
  body('email')
    .isLength({ min: 1, max: 256 })
    .withMessage('email is required, max 256 characters'),
  body('password')
    .isLength({ min: 10, max: 256 })
    .withMessage('password is required, min 10 characters, max 256 characters'),
];

export const loginValidationMiddleware = [
  body('username')
    .isLength({ min: 1, max: 256 })
    .withMessage('username is required, max 256 characters'),
  body('password')
    .isLength({ min: 10, max: 256 })
    .withMessage('password is required, min 10 characters, max 256 characters'),
];

export const seasonsValidationMiddleware = [
  body('name')
    .isLength({ min: 1, max: 256 })
    .withMessage('name is required, max 256 characters'),
  body('number')
    .notEmpty()
    .isInt({ min: 1 })
    .withMessage('number is required, minimum value is 1'),
  body('serie')
    .isLength({ min: 1, max: 256 })
    .withMessage('serie is required, max 256 characters'),
  body('overview').isLength({ max: 256 })
    .optional()
    .withMessage('max 256 characters'),
  body('inProduction')
    .isBoolean()
    .optional()
    .withMessage('inProduction is either true or false'),
  body('poster')
    .notEmpty()
    .withMessage('image is'),

];

export const seriesValidationMiddleware = [
  body('name')
    .notEmpty()
    .isLength({ min: 1, max: 256 })
    .withMessage('name is required, max 256 characters'),
  body('image')
    .notEmpty()
    .withMessage('image is required'),
  body('inProduction')
    .isBoolean()
    .optional()
    .withMessage('inProduction is either true or false'),
  body('url')
    .isLength({ max: 256 })
    .optional()
    .withMessage('max 256 characters'),
  body('tagline').isLength({ max: 256 })
    .optional()
    .withMessage('max 256 characters'),
  body('description').isLength({ max: 256 })
    .optional()
    .withMessage('max 256 characters'),

];

export const rateValidationMiddleware = [
  body('rating')
    .isInt({ min: 0, max: 5 })
    .withMessage('rating must be an integer, one of 0, 1, 2, 3, 4, 5'),

];
export const stateValidationMiddleware = [
  body('state')
    .notEmpty()
    .isIn(['want to watch', 'watching', 'watched'])
    // eslint-disable-next-line no-useless-escape
    .withMessage('state must be one of \"want to watch\", \"watching\", \"watched\"'),

];
export function catchErrors(fn) {
  return (req, res, next) => fn(req, res, next).catch(next);
}
export const userAdminValidationMiddleware = [
  body('admin')
    .isLength({ min: 1 })
    .isBoolean()
    .withMessage('admin is required, either true or false'),
];
// Viljum keyra sér og með validation, ver gegn „self XSS“
export const xssSanitizationMiddleware = [
  body('username').customSanitizer((v) => xss(v)),
  body('email').customSanitizer((v) => xss(v)),
];

export const superSanitizationMiddleware = [
  body('username').optional().customSanitizer((v) => xss(v)),
  body('email').optional().customSanitizer((v) => xss(v)),
  body('image').optional().customSanitizer((v) => xss(v)),
  body('poster').optional().customSanitizer((v) => xss(v)),
  body('admin').optional().customSanitizer((v) => xss(v)),
  body('overview').optional().customSanitizer((v) => xss(v)),
  body('description').optional().customSanitizer((v) => xss(v)),
  body('network').optional().customSanitizer((v) => xss(v)),
  body('url').optional().customSanitizer((v) => xss(v)),
  body('tagline').optional().customSanitizer((v) => xss(v)),
];

export const sanitizationMiddleware = [
  body('username').trim().escape(),
];

export async function validationCheck(req, res, next) {
  const validation = validationResult(req);
  if (!validation.isEmpty()) {
    return res.send(validation.errors);
  }

  return next();
}

export async function isSeriesValid(req, res, next) {
  const { id } = req.params;
  // console.log(id);
  if (await checkIfSeriesExistsById(id)) {
    next();
  } else {
    res.status(404);
    res.json(JSON.parse('{"errors":[{ "msg": "not found", "param": "id", "location": "params"}]}'));
  }
}

export async function isSeasonValid(req, res, next) {
  const { id, seid } = req.params;
  if (await checkIfSeasonExistsBySerieIdAndSeasonNumber(id, seid)) {
    next();
  } else {
    res.status(404);
    res.json(JSON.parse('{"errors":[{ "msg": "not found", "param": "id", "location": "params"}]}'));
  }
}

export async function isImageValid(req, res, next) {
  const { mimetype = '' } = req.file;
  if (mimetype === 'image/png'
    || mimetype === 'image/jpeg'
    || mimetype === 'image/gif') {
    next();
  }
  res.status(422).json(JSON.parse('{"errors":[{ "msg": "Invalid file type", "param": "image", "location": "params"}]}'));
}
