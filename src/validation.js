import { body, validationResult } from 'express-validator';
import xss from 'xss';

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
