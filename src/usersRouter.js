import express from 'express';
import { Strategy } from 'passport-local';
import passport, {
  strat, requireAuthentication, loginUser, jwtOptions, isAdmin, getUserIdFromToken,
} from './login.js';

import {
  createUser, findById, findByUsername, getAllUsers, updateUserAdmin, updateUser,
} from './users.js';
import { generateJson, getFilteredUser } from './helpers.js';
import {
  validationMiddleware, xssSanitizationMiddleware, validationCheck,
  superSanitizationMiddleware, loginValidationMiddleware, catchErrors, 
  userAdminValidationMiddleware,
} from './validation.js';

// The root of this router is /users as defined in app.js
export const router = express.Router();
passport.use(new Strategy(jwtOptions, strat));
router.use(passport.initialize());

router.get('/', requireAuthentication, isAdmin, async (req, res) => {
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
  superSanitizationMiddleware,
  loginUser);

router.post('/register',
  validationMiddleware,
  xssSanitizationMiddleware,
  catchErrors(validationCheck),
  superSanitizationMiddleware,
  async (req, res) => {
    const user = await createUser(req);
    res.json(getFilteredUser(user));
  });

router.get('/me', requireAuthentication, async (req, res) => {
  const authorization = req.headers.authorization.split(' ')[1];
  const userID = (getUserIdFromToken(authorization));
  const user = await findByUsername(userID);
  const filteredUser = getFilteredUser(user);
  res.json(filteredUser);
});

router.patch('/me', requireAuthentication, async (req, res) => {
  const { email, password } = req.body;
  if (!email && !password) res.json({ error: 'please provide atleast email or password' });
  const authorization = req.headers.authorization.split(' ')[1];
  const userID = (getUserIdFromToken(authorization));
  const user = await findByUsername(userID);
  const changed = await updateUser(email, password, user.id);
  const filteredUser = getFilteredUser(changed);
  res.json(filteredUser);
});

router.get('/:id?', requireAuthentication, isAdmin, async (req, res) => {
  const { id } = req.params;
  const user = await findById(id);
  const filteredUser = getFilteredUser(user);
  res.json(filteredUser);
});

router.patch('/:id?', requireAuthentication, isAdmin, userAdminValidationMiddleware, catchErrors(validationCheck), async (req, res) => {
  const { id } = req.params;
  const { admin } = req.body;
  if (!admin) {
    res.json({ error: 'admin is required, either true or false' });
  }
  const user = await updateUserAdmin(admin, id);
  if (!user) {
    res.json({ error: 'operation failed' });
  }

  res.json(getFilteredUser(user));
});
