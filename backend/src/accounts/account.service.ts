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
      // {
      //   id: uuid(),
      //   userId,
      //   institutionId: 'bank-icici',
      //   institutionType: InstitutionType.BANK, // ✅ FIX
      //   accountName: 'ICICI Savings Account',
      //   accountNumberMasked: 'XXXX1234',
      //   status: 'ACTIVE',
      //   lastSyncedAt: new Date(),
      // },
      // {
      //   id: uuid(),
      //   userId,
      //   institutionId: 'broker-zerodha',
      //   institutionType: InstitutionType.BROKER, // ✅ FIX
      //   accountName: 'Zerodha Trading Account',
      //   accountNumberMasked: 'XXXX5678',
      //   status: 'ACTIVE',
      //   lastSyncedAt: new Date(),
      // },

      // ======================================================
      // ✅ ADDED — US BANK ACCOUNTS
      // ======================================================

      {
        id: uuid(),
        userId,
        institutionId: 'bank-chase-us',              // ✅ ADDED
        institutionType: InstitutionType.BANK,       // ✅ ADDED
        accountName: 'Chase Checking Account',       // ✅ ADDED
        accountNumberMasked: 'XXXX4321',              // ✅ ADDED
        status: 'ACTIVE',                              // ✅ ADDED
        lastSyncedAt: new Date(),                      // ✅ ADDED
      },

      {
        id: uuid(),
        userId,
        institutionId: 'bank-bankofamerica-us',      // ✅ ADDED
        institutionType: InstitutionType.BANK,       // ✅ ADDED
        accountName: 'Bank of America Savings',      // ✅ ADDED
        accountNumberMasked: 'XXXX8765',              // ✅ ADDED
        status: 'ACTIVE',                              // ✅ ADDED
        lastSyncedAt: new Date(),                      // ✅ ADDED
      },

      {
        id: uuid(),
        userId,
        institutionId: 'bank-wellsfargo-us',         // ✅ ADDED
        institutionType: InstitutionType.BANK,       // ✅ ADDED
        accountName: 'Wells Fargo Checking',         // ✅ ADDED
        accountNumberMasked: 'XXXX2468',              // ✅ ADDED
        status: 'ACTIVE',                              // ✅ ADDED
        lastSyncedAt: new Date(),                      // ✅ ADDED
      },

      // ======================================================
      // ✅ ADDED — US BROKER ACCOUNTS
      // ======================================================

      {
        id: uuid(),
        userId,
        institutionId: 'broker-robinhood-us',        // ✅ ADDED
        institutionType: InstitutionType.BROKER,    // ✅ ADDED
        accountName: 'Robinhood Investing Account', // ✅ ADDED
        accountNumberMasked: 'XXXX1111',              // ✅ ADDED
        status: 'ACTIVE',                              // ✅ ADDED
        lastSyncedAt: new Date(),                      // ✅ ADDED
      },

      {
        id: uuid(),
        userId,
        institutionId: 'broker-fidelity-us',         // ✅ ADDED
        institutionType: InstitutionType.BROKER,    // ✅ ADDED
        accountName: 'Fidelity Brokerage Account',  // ✅ ADDED
        accountNumberMasked: 'XXXX2222',              // ✅ ADDED
        status: 'ACTIVE',                              // ✅ ADDED
        lastSyncedAt: new Date(),                      // ✅ ADDED
      },

      {
        id: uuid(),
        userId,
        institutionId: 'broker-charlesschwab-us',    // ✅ ADDED
        institutionType: InstitutionType.BROKER,    // ✅ ADDED
        accountName: 'Charles Schwab Brokerage',    // ✅ ADDED
        accountNumberMasked: 'XXXX3333',              // ✅ ADDED
        status: 'ACTIVE',                              // ✅ ADDED
        lastSyncedAt: new Date(),                      // ✅ ADDED
      },
    ];

    this.accounts.push(...mockAccounts);
    return mockAccounts;
  }

  findAll(userId: string) {
    return this.accounts.filter(a => a.userId === userId);
  }
}

