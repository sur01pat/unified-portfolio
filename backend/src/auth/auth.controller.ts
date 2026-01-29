import { Body, Controller, Post } from '@nestjs/common';
import { ApiTags, ApiBody, ApiOperation } from '@nestjs/swagger';
import { AuthService } from './auth.service';

@ApiTags('Auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('send-otp')
  @ApiOperation({ summary: 'Send OTP to mobile number' })
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        mobileNumber: { type: 'string', example: '+919876543210' },
      },
    },
  })
  sendOtp(@Body() body: { mobileNumber: string }) {
    return this.authService.sendOtp(body.mobileNumber);
  }

  @Post('verify-otp')
  @ApiOperation({ summary: 'Verify OTP and issue JWT' })
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        mobileNumber: { type: 'string', example: '+919876543210' },
        code: { type: 'string', example: '123456' },
      },
    },
  })
  verifyOtp(@Body() body: { mobileNumber: string; code: string }) {
    return this.authService.verifyOtp(body.mobileNumber, body.code);
  }
}
