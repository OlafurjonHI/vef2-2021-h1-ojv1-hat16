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
