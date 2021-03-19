import dotenv from 'dotenv';
import cloudinary from 'cloudinary';


/**
 * Passa að hafa eftirfarandi í .env
 * CLOUDINARY_URL=cloudinary://674252999368618:_2Wdp8hH2sjb83MOyJSWo9fc3Oc@vef2-2021-h2
 */
dotenv.config();

const {
  CLOUDINARY_URL,
} = process.env;

