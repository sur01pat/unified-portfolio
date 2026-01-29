import { Controller, Get, Post, Req, UseGuards } from '@nestjs/common';
import { AccountService } from './account.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';

@ApiTags('Accounts (V2)')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('v2/accounts')
export class AccountsController {
  constructor(private readonly accountService: AccountService) {}

  @Post('seed')
  seed(@Req() req) {
    return this.accountService.seedMockAccounts(req.user.sub);
  }

  @Get()
  findAll(@Req() req) {
    return this.accountService.findAll(req.user.sub);
  }
}
