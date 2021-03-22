import csv from 'csvtojson';
import {
  createSeries, createSeasons, createEpisodes, addGenresSeriesConnection,
} from './tv.js';
import { createAdmin, createUser } from './users.js';

const seriesCSV = './data/series.csv';
const seasonsCSV = './data/seasons.csv';
const episodesCSV = './data/episodes.csv';

const insertEpisodes = async () => {
  const episodes = await csv().fromFile(episodesCSV);
  episodes.forEach(async (e) => {
    await createEpisodes(e);
  });
};

const insertSeasons = async () => {
  const seasons = await csv().fromFile(seasonsCSV);
  seasons.forEach(async (s) => {
    await (createSeasons(s));
  });
};

const insertSeries = async () => {
  try {
    const series = await csv().fromFile(seriesCSV);
    series.forEach(async (s) => {
      await createSeries(s);
      s.genres.split(',').forEach(async (g) => {
        await addGenresSeriesConnection(s.id, g);
      });
    });
  } catch (e) {
    console.error(e.message);
  }
};

const setup = async () => {
  // insertSeries();
  insertSeasons();
  // insertEpisodes();
  // createAdmin();
  // const req = {};
  // req.body = { username: 'verybasicuser', password: '1234567890', email: 'avarage@joe.is' };
  // createUser(req);
};

setup();
