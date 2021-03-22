/* eslint-disable camelcase */
import dotenv from 'dotenv';
import cloudinary from 'cloudinary';

dotenv.config();

const {
  cloud_name,
  api_key,
  api_secret,
} = process.env;

cloudinary.v2.config({
  cloud_name,
  api_key,
  api_secret,
});

/**
 *
 *
 * @param image path to image to be uploaded
 */
export async function uploadImg(image) {
  return new Promise((resolve, reject) => {
    cloudinary.v2.uploader.upload(image, (error, result) => {
      if (error) return reject(error);
      return resolve(result.url);
    });
  });
}

