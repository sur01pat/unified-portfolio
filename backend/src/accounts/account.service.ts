import { Injectable } from '@nestjs/common';
import { Account } from './account.entity';
import { v4 as uuid } from 'uuid';
import { InstitutionType } from '../institutions/institution.entity';

@Injectable()
export class AccountService {
  private accounts: Account[] = [];

  seedMockAccounts(userId: string) {
    this.accounts = this.accounts.filter(
      a => a.userId !== userId,
    );

    const mockAccounts: Account[] = [
      {
        id: uuid(),
        userId,
        institutionId: 'bank-icici',
        institutionType: InstitutionType.BANK, // ✅ FIX
        accountName: 'ICICI Savings Account',
        accountNumberMasked: 'XXXX1234',
        status: 'ACTIVE',
        lastSyncedAt: new Date(),
      },
      {
        id: uuid(),
        userId,
        institutionId: 'broker-zerodha',
        institutionType: InstitutionType.BROKER, // ✅ FIX
        accountName: 'Zerodha Trading Account',
        accountNumberMasked: 'XXXX5678',
        status: 'ACTIVE',
        lastSyncedAt: new Date(),
      },
    ];

    this.accounts.push(...mockAccounts);
    return mockAccounts;
  }

  findAll(userId: string) {
    return this.accounts.filter(a => a.userId === userId);
  }
}

