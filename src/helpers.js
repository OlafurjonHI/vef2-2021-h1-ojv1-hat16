/* eslint-disable no-underscore-dangle */
export const generateJson = (limit, offset, items, total, path) => {
  const jsonObject = {};
  jsonObject.limit = limit;
  jsonObject.offset = offset;
  jsonObject.items = items;
  jsonObject._links = {
    self: `${path}?offset=${offset}&limit=${limit}`, // virðast sýnast prev þrátt fyrir að "eiga ekki prev" í sýnilausn svo held því inni
    prev: `${path}?offset=${(offset - limit >= 0) ? offset - limit : 0}&limit=${limit}`,
  };
  if (offset + limit < total) {
    jsonObject._links.next = `${path}?offset=${offset + limit}&limit=${limit}`;
  }
  return (jsonObject);
};
