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
export function uploadImg(image) {
  cloudinary.v2.uploader.upload(image, (error, result) => {
    // eslint-disable-next-line no-console
    console.log(result.url);
    return result.url;
  });
}
