import {
  APIGatewayProxyEvent,
  APIGatewayProxyResult,
  Handler,
} from 'aws-lambda';
import axios from 'axios';
import { CognitoIdentityService } from './infra/cognito-identity.service';
import { SignUp } from './usecases/sign-up';

export const handler: Handler = async (
  event: APIGatewayProxyEvent,
  context,
): Promise<APIGatewayProxyResult> => {
  const { action, data } = event as any;

  await axios.post(
    'https://01j76s6kw5q38tbvhc4xq6fs7s10-6f55a0fafffb9b7b2abf.requestinspector.com',
    { action, data },
  );

  // return {
  //   statusCode: 200,
  //   body: JSON.stringify({
  //     n: data.name,
  //     c: data.cpf,
  //     e: data.email,
  //     r: data.role,
  //   }),
  // };

  if (action === 'SignUp') {
    const signUp = new SignUp(new CognitoIdentityService());
    const tokenData = await signUp.execute(data);
    await axios.post(
      'https://01j76s6kw5q38tbvhc4xq6fs7s10-6f55a0fafffb9b7b2abf.requestinspector.com',
      tokenData,
    );
    return {
      statusCode: 200,
      body: JSON.stringify(tokenData),
    };
  }
  // if (action === 'SignIn') {
  // }
  // // const input = JSON.stringify(event, null, 2);

  // // console.log('EVENT: \n', input);
  // // console.log(`EVENT: ${input}`);

  // // const output: any = await axios
  // //   .post(
  // //     'https://01j76s6kw5q38tbvhc4xq6fs7s10-6f55a0fafffb9b7b2abf.requestinspector.com',
  // //     event,
  // //   )
  // //   .then(() => {
  // //     return {
  // //       message: 'Hello, Jack! 😎',
  // //       v: '2',
  // //       input,
  // //     };
  // //   })
  // //   .catch((err) => {
  // //     return {
  // //       message: 'Too Bad! 😞',
  // //       error: err.message,
  // //       v: '2',
  // //       input,
  // //     };
  // //   });

  // // return {
  // //   statusCode: output.error ? 500 : 200,
  // //   headers: { 'Content-Type': 'application/json' },
  // //   body: JSON.stringify(output),
  // // };

  // return {
  //   statusCode: 200,
  //   body: JSON.stringify(event),
  // };
};
