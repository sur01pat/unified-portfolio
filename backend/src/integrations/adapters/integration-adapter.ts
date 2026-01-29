export interface IntegrationAdapter {
  providerId(): string;

  fetchAccounts(userId: string): Promise<any[]>;
  fetchHoldings(userId: string): Promise<any[]>;
  fetchFixedDeposits?(userId: string): Promise<any[]>;
}
