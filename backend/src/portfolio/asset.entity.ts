export enum AssetType {
  STOCK = 'STOCK',
  ETF = 'ETF',
  MUTUAL_FUND = 'MUTUAL_FUND',
  CRYPTO = 'CRYPTO',
  GOLD = 'GOLD',
  FIXED_INCOME = 'FIXED_INCOME',
  REAL_ESTATE = 'REAL_ESTATE',
  CASH = 'CASH',
}

/**
 * 🔹 Defines how the asset entered the system.
 * - MANUAL: User-entered (Gold, Cash, Real Estate)
 * - BANK: Imported from bank (FD, Savings)
 * - BROKER: Imported from broker (Stocks, ETFs)
 */
export enum AssetSource {
  MANUAL = 'MANUAL',
  BANK = 'BANK',
  BROKER = 'BROKER',
}

export class Asset {
  id: string;
  userId: string;

  type: AssetType;
  source?: AssetSource; // ✅ OPTIONAL (no side effects)

  name: string;
  symbol?: string;

  quantity: number;
  purchasePrice: number;
  currency: string;

  sector?: string;
  country?: string;
  platform?: string;

  /**
   * 🔹 Fixed Income lifecycle (OPTIONAL)
   * Used only when type === FIXED_INCOME
   */
  startDate?: Date;
  maturityDate?: Date;
  interestRate?: number;

  createdAt: Date;
}
