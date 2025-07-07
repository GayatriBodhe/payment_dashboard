import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Payment } from './payment.entity';
import { PageOptionsDto } from '../dto/page-options.dto';
import { PageDto } from '../dto/page.dto';

@Injectable()
export class PaymentsService {
  constructor(
    @InjectRepository(Payment) private readonly paymentRepository: Repository<Payment>,
  ) {}

  async findAll(pageOptions: PageOptionsDto): Promise<PageDto<Payment>> {
    const { page = 1, limit = 10, status, method } = pageOptions;
    const query = this.paymentRepository.createQueryBuilder('payment');
  
    if (status) query.andWhere('payment.status = :status', { status });
    if (method) query.andWhere('payment.method = :method', { method });
  
    const [data, total] = await query
      .skip((page - 1) * limit)
      .take(limit)
      .getManyAndCount();
  
    return {
      data: data || [], // Ensure data is never null
      total,
      page,
      limit,
    };
  }

  async getStats() {
    const today = new Date();
    today.setHours(0, 0, 0, 0); // Start of July 07, 2025
    const weekAgo = new Date(today);
    weekAgo.setDate(today.getDate() - 7);
  
    const totalToday = await this.paymentRepository
      .createQueryBuilder('payment')
      .where('payment.created_at >= :today', { today })
      .getCount();
  
    const totalWeek = await this.paymentRepository
      .createQueryBuilder('payment')
      .where('payment.created_at >= :weekAgo', { weekAgo })
      .getCount();
  
    const revenue = await this.paymentRepository
      .createQueryBuilder('payment')
      .where('payment.status = :status', { status: 'success' })
      .select('SUM(payment.amount)', 'revenue')
      .getRawOne();
  
    const failedTransactions = await this.paymentRepository
      .createQueryBuilder('payment')
      .where('payment.status = :status', { status: 'failed' })
      .getCount();
  
    return {
      totalTransactionsToday: totalToday || 0,
      totalTransactionsWeek: totalWeek || 0,
      revenue: revenue?.revenue || '0',
      failedTransactions: failedTransactions || 0,
    };
  }
}