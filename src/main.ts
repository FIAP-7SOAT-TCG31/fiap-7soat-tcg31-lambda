import {
  APIGatewayProxyEvent,
  APIGatewayProxyResult,
  Handler,
} from 'aws-lambda';
import axios from 'axios';

export const handler: Handler = async (
  event: APIGatewayProxyEvent,
  context,
): Promise<APIGatewayProxyResult> => {
  const input = JSON.stringify(event, null, 2);
  console.log('EVENT: \n', input);
  console.log(`EVENT: ${input}`);

  const output: any = await axios
    .post(
      'https://01j76s6kw5q38tbvhc4xq6fs7s10-6f55a0fafffb9b7b2abf.requestinspector.com',
      event,
    )
    .then(() => {
      return {
        message: 'Hello, Jack! 😎',
        v: "2",
        input,
      };
    })
    .catch((err) => {
      return {
        message: 'Too Bad! 😞',
        error: err.message,
        v: "2",
        input,
      };
    });

  return {
    statusCode: output.error ? 500 : 200,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(output),
  };
};
