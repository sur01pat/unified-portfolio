import { Injectable, UnauthorizedException } from '@nestjs/common';
import { otpStore } from './otp.store';
import { randomInt } from 'crypto';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthService {
  constructor(private readonly jwtService: JwtService) {}

  sendOtp(mobileNumber: string) {
    const otp = randomInt(100000, 999999).toString();

    otpStore.set(mobileNumber, {
      mobileNumber,
      code: otp,
      expiresAt: Date.now() + 5 * 60 * 1000, // 5 mins
      attempts: 0,
    });

    console.log(`OTP for ${mobileNumber}: ${otp}`);

    return { success: true };
  }

  verifyOtp(mobileNumber: string, code: string) {
    const entry = otpStore.get(mobileNumber);

    if (!entry) {
      throw new UnauthorizedException('OTP not found');
    }

    if (Date.now() > entry.expiresAt) {
      otpStore.delete(mobileNumber);
      throw new UnauthorizedException('OTP expired');
    }

    if (entry.attempts >= 3) {
      otpStore.delete(mobileNumber);
      throw new UnauthorizedException('Too many attempts');
    }

    if (entry.code !== code) {
      entry.attempts += 1;
      throw new UnauthorizedException('Invalid OTP');
    }

    otpStore.delete(mobileNumber);

    // ✅ NORMALIZE USER ID (THIS IS THE FIX)
    const normalizedUserId = mobileNumber.startsWith('+')
      ? mobileNumber
      : `+${mobileNumber}`;

    // ✅ Issue JWT with normalized userId
    const token = this.jwtService.sign({
      sub: normalizedUserId,
    });

    return {
      accessToken: token,
    };
  }
}
