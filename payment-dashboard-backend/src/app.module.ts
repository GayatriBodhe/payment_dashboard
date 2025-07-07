import { Module, OnModuleInit } from '@nestjs/common';
import { InjectRepository, TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { PaymentsModule } from './payments/payments.module';
import { User } from './users/user.entity';
import { Payment } from './payments/payment.entity';
import * as bcrypt from 'bcrypt';
import { Repository } from 'typeorm'; // Add this import

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DATABASE_HOST,
      port: parseInt(process.env.DATABASE_PORT),
      username: process.env.DATABASE_USER,
      password: process.env.DATABASE_PASSWORD,
      database: process.env.DATABASE_NAME,
      entities: [__dirname + '/**/*.entity{.ts,.js}'],
      synchronize: true,
    }),
    TypeOrmModule.forFeature([User, Payment]),
    AuthModule,
    UsersModule,
    PaymentsModule,
  ],
})
export class AppModule implements OnModuleInit {
  constructor(
    private readonly configService: ConfigService,
    @InjectRepository(User) private readonly usersRepository: Repository<User>, // Use @InjectRepository
    @InjectRepository(Payment) private readonly paymentsRepository: Repository<Payment>, // Use @InjectRepository
  ) {}

  async onModuleInit() {
    const adminExists = await this.usersRepository.findOne({ where: { username: 'admin' } });
    if (!adminExists) {
      const hashedPassword = await bcrypt.hash('admin123', 10);
      const admin = this.usersRepository.create({
        username: 'admin',
        password: hashedPassword,
        role: 'admin',
        created_at: new Date(),
      });
      await this.usersRepository.save(admin);
    }

    const paymentsCount = await this.paymentsRepository.count();
    if (paymentsCount === 0) {
      const mockPayments = [
        { amount: 100, method: 'card', receiver: 'user1', status: 'success', created_at: new Date() },
        { amount: 200, method: 'UPI', receiver: 'user2', status: 'failed', created_at: new Date() },
        { amount: 150, method: 'bank', receiver: 'user3', status: 'pending', created_at: new Date() },
      ];
      await this.paymentsRepository.save(mockPayments);
    }
  }
}