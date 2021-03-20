export const generateJson = (limit, offset, items, path) => {
  const jsonObject = {};
  jsonObject.limit = limit;
  jsonObject.offset = offset;
  jsonObject.items = items;
  // eslint-disable-next-line no-underscore-dangle
  jsonObject._links = {
    self: `${path}?offset=${offset}&limit=${limit}`,
    prev: `${path}?offset=${(offset - limit >= 0) ? offset - limit : 0}&limit=${limit}`,
    next: `${path}?offset=${offset + limit}&limit=${limit}`,
  };
  return JSON.stringify(jsonObject);
};
