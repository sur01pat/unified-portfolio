import { Injectable } from '@nestjs/common';
import { v4 as uuid } from 'uuid';
import {
  Consent,
  ConsentStatus,
} from './consent.entity';

@Injectable()
export class ConsentService {
  private consents: Consent[] = [];

  grant(
    userId: string,
    providerId: string,
    scopes: string[],
    ttlDays = 180,
  ): Consent {
    // revoke any existing active consent
    this.consents = this.consents.map(c =>
      c.userId === userId &&
      c.providerId === providerId &&
      c.status === ConsentStatus.ACTIVE
        ? { ...c, status: ConsentStatus.REVOKED }
        : c,
    );

    const consent: Consent = {
      id: uuid(),
      userId,
      providerId,
      scopes,
      grantedAt: new Date(),
      expiresAt: new Date(
        Date.now() + ttlDays * 24 * 60 * 60 * 1000,
      ),
      status: ConsentStatus.ACTIVE,
    };

    this.consents.push(consent);
    return consent;
  }

  list(userId: string): Consent[] {
    return this.consents.filter(
      c => c.userId === userId,
    );
  }

  revoke(userId: string, consentId: string) {
    const c = this.consents.find(
      x => x.id === consentId && x.userId === userId,
    );
    if (c) c.status = ConsentStatus.REVOKED;
    return c;
  }

  expireIfNeeded() {
    const now = new Date();
    this.consents.forEach(c => {
      if (
        c.status === ConsentStatus.ACTIVE &&
        c.expiresAt &&
        c.expiresAt < now
      ) {
        c.status = ConsentStatus.EXPIRED;
      }
    });
  }

  hasActiveConsent(
    userId: string,
    providerId: string,
  ): boolean {
    this.expireIfNeeded();
    return this.consents.some(
      c =>
        c.userId === userId &&
        c.providerId === providerId &&
        c.status === ConsentStatus.ACTIVE,
    );
  }
}
