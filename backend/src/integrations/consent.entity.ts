export enum ConsentStatus {
  ACTIVE = 'ACTIVE',
  REVOKED = 'REVOKED',
  EXPIRED = 'EXPIRED',
}

export class Consent {
  id: string;
  userId: string;
  providerId: string;

  scopes: string[];
  grantedAt: Date;
  expiresAt?: Date;

  status: ConsentStatus;
}
