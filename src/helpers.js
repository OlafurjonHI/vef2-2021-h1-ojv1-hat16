/* eslint-disable no-underscore-dangle */
export const generateJson = (limit, offset, items, total, path) => {
  const jsonObject = {};
  jsonObject.limit = limit;
  jsonObject.offset = offset;
  jsonObject.items = items;
  jsonObject._links = {};
  if (offset - limit >= 0) jsonObject._links.prev = { href: `http://${path}?offset=${offset - limit}&limit=${limit}` };
  jsonObject._links.self = { href: `http://${path}?offset=${offset}&limit=${limit}` };
  if (offset + limit < total) jsonObject._links.next = { href: `http://${path}?offset=${offset + limit}&limit=${limit}` };
  return jsonObject;
};

export const getFilteredUser = (user) => {
  const {
    username, email, admin, created, updated,
  } = user;
  const filteredUser = {};
  filteredUser.id = user.id;
  filteredUser.username = username;
  filteredUser.email = email;
  filteredUser.admin = admin;
  filteredUser.created = created;
  filteredUser.updated = updated;
  return filteredUser;
};
