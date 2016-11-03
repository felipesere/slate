
var async = require('async');
var AWS = require('aws-sdk');
var gm = require('gm').subClass({"imageMagick" : true});
var util = require('util');

var s3 = new AWS.S3();

module.exports.resize = (event, context, callback) => {
  "use strict";

  var s3data = event.Records[0].s3;
  async.waterfall([
      function download(next) {
        console.log("Starting to do download " + s3data.object.key);
        s3.getObject({
          Bucket: s3data.bucket.name,
          Key: s3data.object.key
        }, next);
      },
      function shrink(data, next) {
        console.log("Starting to do shring... ");
        console.log(util.inspect(data));
        gm(data.Body)
          .resize(100, 100)
          .toBuffer('jpg', function (err, buffer) {
            if (err) {
              next(err);
            } else {
              next(null, data.ContentType, buffer);
            }
          });
      },
      function uploadToS3(contentType, data, next) {
        console.log("Uploading back to S3");
        s3.putObject({
          Bucket: s3data.bucket.name,
          Key: "small/"+s3data.object.key,
          Body: data,
          ContentType: contentType
        }, next);
      }],
      function(err) {
        console.log("Caught an error: " + err);
        if(err) throw err;
      });
};
