import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { PaymentsService } from './payments.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { PageOptionsDto } from '../dto/page-options.dto';

@Controller('payments')
@UseGuards(JwtAuthGuard)
export class PaymentsController {
  constructor(private readonly paymentsService: PaymentsService) {}

  @Get()
  async findAll(@Query() pageOptions: PageOptionsDto) {
    return this.paymentsService.findAll(pageOptions);
  }

  @Get('stats')
  async getStats() {
    return this.paymentsService.getStats();
  }
}