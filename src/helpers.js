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
