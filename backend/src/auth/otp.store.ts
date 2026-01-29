export interface OtpEntry {
  mobileNumber: string;
  code: string;
  expiresAt: number;
  attempts: number;
}

export const otpStore = new Map<string, OtpEntry>();
