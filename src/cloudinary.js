/* eslint-disable camelcase */
import dotenv from 'dotenv';
import cloudinary from 'cloudinary';
import { CloudinaryStorage } from 'multer-storage-cloudinary';
import streamifier from 'streamifier';

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

export async function uploadStream(buffer) {
  return new Promise((resolve, reject) => {
    cloudinary.uploader.upload_stream(buffer, (error, result) => {
      if (error) return reject(error);
      return resolve(result);
    });
  });
}

export const streamUpload = (req) => new Promise((resolve, reject) => {
  const stream = cloudinary.uploader.upload_stream(
    (error, result) => {
      if (result) {
        resolve(result);
      } else {
        reject(error);
      }
    },
  );
  streamifier.createReadStream(req.file.buffer).pipe(stream);
});

export const upload = async (req) => {
    console.log(req.files);
};
export const storage = new CloudinaryStorage({
  cloudinary,
  params:{
    folder: (req,file) =>'folder_name',
  },
});

/* export async function uploadStream(buffer) {
  const result = cloudinary.uploader.upload_stream(buffer);
  return result;
} */
