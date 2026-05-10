const { S3Client, PutObjectCommand } = require("@aws-sdk/client-s3");

const crypto = require("crypto");
const s3 = new S3Client({});

exports.handler = async (event) => {

  const body = JSON.parse(event.body || "{}");
  const now = new Date();
  const sourceIp = event.requestContext?.http?.sourceIp || null;

  const eventName = body.event || "unknown";

  const key =
    `year=${now.getUTCFullYear()}` +
    `/month=${String(now.getUTCMonth() + 1).padStart(2, '0')}` +
    `/day=${String(now.getUTCDate()).padStart(2, '0')}` +
    `/event=${eventName}` +
    `/${crypto.randomUUID()}.json`;

  const payload = {
    receivedAt: now.toISOString(),
    sourceIp,
    ...body
  };

  await s3.send(
    new PutObjectCommand({
      Bucket: process.env.ANALYTICS_BUCKET,
      Key: key,
      Body: JSON.stringify(payload),
      ContentType: "application/json"
    })
  );

  return {
    statusCode: 204
  };
};