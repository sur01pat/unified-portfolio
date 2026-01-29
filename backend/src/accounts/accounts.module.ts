import { Module } from '@nestjs/common';
import { AccountService } from './account.service';
import { AccountsController } from './accounts.controller';

@Module({
  providers: [AccountService],
  controllers: [AccountsController],
  exports: [AccountService],
})
export class AccountsModule {}

