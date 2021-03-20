import passport from 'passport';
import dotenv from 'dotenv';
import { Strategy, ExtractJwt } from 'passport-jwt';
import jwt from 'jsonwebtoken';
import { comparePasswords, findByUsername } from './users.js';

dotenv.config();

const {
  SESSION_SECRET: jwtSecret,
  TOKEN_LIFETIME: tokenLifetime = 3600,
} = process.env;

if (!jwtSecret) {
  console.error('Vantar .env gildi - jwtSecret');
  process.exit(1);
}

export const jwtOptions = {
  jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
  secretOrKey: jwtSecret,
};

export async function strat(data, next) {
  // fáum id gegnum data sem geymt er í token
  const user = await findByUsername(data.id);

  if (user) {
    next(null, user);
  } else {
    next(null, false);
  }
}
passport.use(new Strategy(jwtOptions, strat));

export async function loginUser(req, res) {
  const { username, password = '' } = req.body;
  const user = await findByUsername(username);
  if (!user) {
    return res.status(401).json({ error: 'No such user' });
  }

  const passwordIsCorrect = await comparePasswords(password, user.password);

  if (passwordIsCorrect) {
    const payload = { id: user.username };
    const tokenOptions = { expiresIn: tokenLifetime };
    const token = jwt.sign(payload, jwtOptions.secretOrKey, tokenOptions);
    const result = {};
    result.user = user;
    result.token = token;
    result.expiresIn = tokenLifetime;
    return res.json(result);
  }

  return res.status(401).json({ error: 'Invalid password' });
}

export function isAdmin(req, res, next) {
  if (req.user.admin) {
    next();
  }
  res.status(401).json({ error: 'Unauthorized' });
}

export function requireAuthentication(req, res, next) {
  return passport.authenticate(
    'jwt',
    { session: false },
    (err, user, info) => {
      if (err) {
        return next(err);
      }
      if (!user) {
        const error = info.name === 'TokenExpiredError'
          ? 'expired token' : 'invalid token';

        return res.status(401).json({ error });
      }
      // Látum notanda vera aðgengilegan í rest af middlewares
      req.user = user;
      return next();
    },
  )(req, res, next);
}
export default passport;
