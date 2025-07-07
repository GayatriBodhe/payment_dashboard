export class PageDto<T> {
    data: T[];
    total: number;
    page: number;
    limit: number;
  }