import { IntegrationAdapter } from './integration-adapter';

export class MockAAAdapter implements IntegrationAdapter {
  providerId(): string {
    return 'mock-aa';
  }

  async fetchAccounts(userId: string) {
    return [
      {
        accountName: 'HDFC Savings',
        maskedNumber: 'XXXX1111',
      },
    ];
  }

  async fetchHoldings(userId: string) {
    return [];
  }

  async fetchFixedDeposits(userId: string) {
    return [
      {
        name: 'HDFC FD',
        amount: 500000,
        maturityDays: 180,
        interestRate: 7.1,
      },
    ];
  }
}
