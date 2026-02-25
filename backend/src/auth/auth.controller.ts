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

    // ✅ ADDED: capture OTP returned from service
    const otp = this.authService.sendOtp(body.mobileNumber);

    // ❌ original line kept as-is
    return this.authService.sendOtp(body.mobileNumber);

    ///
    return {
    message: 'OTP sent',
    otp: otp, // ✅ DEBUG ONLY - allows mobile app to display OTP
  };
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
