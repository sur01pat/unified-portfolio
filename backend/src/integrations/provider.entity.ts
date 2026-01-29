export enum ProviderType {
  BANK = 'BANK',
  BROKER = 'BROKER',
  CRYPTO = 'CRYPTO',
}

export class IntegrationProvider {
  id: string;
  name: string;
  type: ProviderType;
  country: string;

  /// feature flags
  supportsHoldings: boolean;
  supportsTransactions: boolean;
  supportsMaturity: boolean;
}
