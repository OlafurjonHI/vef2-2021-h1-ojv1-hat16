import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

import express from 'express';
import dotenv from 'dotenv';

import { router as tvRouter } from './tvRouter.js';
import { router as userRouter } from './usersRouter.js';
import { router as genresRouter } from './genres.js';

dotenv.config();

const {
  PORT: port = 3000,
  SESSION_SECRET: sessionSecret,
} = process.env;

if (!sessionSecret) {
  console.error('Vantar .env gildi');
  process.exit(1);
}

const app = express();
const path = dirname(fileURLToPath(import.meta.url));
// Sér um að req.body innihaldi gögn úr formi
app.use(express.static(join(path, '../public')));

// Breyti til að prófa smá
app.set('view engine', 'ejs');
// app.use(express.bodyParser());
app.use(express.json()); // Þurfum til að taka á móti json í post

/**
 * Middleware sem sér um 404 villur.
 *
 * @param {object} req Request hlutur
 * @param {object} res Response hlutur
 * @param {function} next Næsta middleware
 */
// eslint-disable-next-line no-unused-vars
function notFoundHandler(req, res, next) {
  res.status(404).json({ error: 'Not found' });
}

/**
 * Middleware sem sér um villumeðhöndlun.
 *
 * @param {object} err Villa sem kom upp
 * @param {object} req Request hlutur
 * @param {object} res Response hlutur
 * @param {function} next Næsta middleware
 */
// eslint-disable-next-line no-unused-vars
function errorHandler(err, req, res, next) {
  console.error(err);
  if (err instanceof SyntaxError && err.status === 400 && 'body' in err) {
    return res.status(400).json({ error: 'Invalid json' });
  }
  return res.status(500).json({ error: 'Internal server error' });
}
app.use('/genres', genresRouter);
app.use('/tv', tvRouter);
app.use('/users', userRouter);

app.get('/', (_, res) => {
  res.json(JSON.parse('{"tv":{"series":{"href":"/tv","methods":["GET","POST"]},"serie":{"href":"/tv/{id}","methods":["GET","PATCH","DELETE"]},"rate":{"href":"/tv/{id}/rate","methods":["POST","PATCH","DELETE"]},"state":{"href":"/tv/{id}/state","methods":["POST","PATCH","DELETE"]}},"seasons":{"seasons":{"href":"/tv/{id}/season","methods":["GET","POST"]},"season":{"href":"/tv/{id}/season/{season}","methods":["GET","DELETE"]}},"episodes":{"episodes":{"href":"/tv/{id}/season/{season}/episode","methods":["POST"]},"episode":{"href":"/tv/{id}/season/{season}/episode/{episode}","methods":["GET","DELETE"]}},"genres":{"genres":{"href":"/genres","methods":["GET","POST"]}},"users":{"users":{"href":"/users","methods":["GET"]},"user":{"href":"/users/{id}","methods":["GET","PATCH"]},"register":{"href":"/users/register","methods":["POST"]},"login":{"href":"/users/login","methods":["POST"]},"me":{"href":"/users/me","methods":["GET","PATCH"]}}}'));
});

app.use(notFoundHandler);
app.use(errorHandler);

// Verðum að setja bara *port* svo virki á heroku
app.listen(port, () => {
  console.info(`Server running at http://localhost:${port}/`);
});
