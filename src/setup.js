import csv from 'csvtojson';
//import { createUser } from './users.js';
import { createSeries, findById } from './tv.js';

const seriesCSV = './data/series.csv';

const insertSeries = async () => {
  try {
    const series = await csv().fromFile(seriesCSV);
    for(const s of series){
      createSeries(s);
    }
  } catch (e) {
    console.log(e.message);
  }
};

const setup = async () => {
  //insertSeries();
  let res = findById(1);
};

setup();
