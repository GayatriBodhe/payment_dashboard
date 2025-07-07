import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity('payments') // Explicitly set table name to 'payments'
export class Payment {
  @PrimaryGeneratedColumn()
  id: number;

  @Column('decimal')
  amount: number;

  @Column()
  method: string;

  @Column()
  receiver: string;

  @Column({ enum: ['success', 'failed', 'pending'] })
  status: string;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  created_at: Date;
}