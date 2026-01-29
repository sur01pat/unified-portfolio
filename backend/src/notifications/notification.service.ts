import { Injectable } from '@nestjs/common';
import { Notification } from './notification.entity';
import { v4 as uuid } from 'uuid';
import { PortfolioMaturityService } from '../portfolio/portfolio-maturity.service';
import { PortfolioAnalysisService } from '../portfolio/portfolio-analysis.service';

@Injectable()
export class NotificationService {
  private notifications: Notification[] = [];

  constructor(
    private readonly maturityService: PortfolioMaturityService,
    private readonly analysisService: PortfolioAnalysisService,
  ) {}

  generate(userId: string): Notification[] {
    const list: Notification[] = [];

    // 🔔 FD Maturity alerts
    const maturities =
      this.maturityService.getMaturities(userId);

    maturities
      .filter(m => m.status === 'DUE_SOON')
      .forEach(m => {
        list.push({
          id: uuid(),
          userId,
          type: 'FD_MATURITY',
          title: 'FD maturing soon',
          message: `${m.name} matures in ${m.daysRemaining} days`,
          severity: 'WARNING',
          createdAt: new Date(),
          read: false,
        });
      });

    // 🔔 Risk alerts
    const analysis =
      this.analysisService.analyze(userId);

    if ((analysis.allocation['Equity'] || 0) > 70) {
      list.push({
        id: uuid(),
        userId,
        type: 'RISK_ALERT',
        title: 'High equity exposure',
        message:
          'Your equity allocation exceeds 70%. Consider rebalancing.',
        severity: 'CRITICAL',
        createdAt: new Date(),
        read: false,
      });
    }

    this.notifications = list;
    return list;
  }

  findAll(userId: string) {
    return this.notifications.filter(
      n => n.userId === userId,
    );
  }

  markRead(userId: string, id: string) {
    const n = this.notifications.find(
      x => x.id === id && x.userId === userId,
    );
    if (n) n.read = true;
  }
}
