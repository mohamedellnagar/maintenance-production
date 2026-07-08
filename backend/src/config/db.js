import mysql from 'mysql2/promise';

function utf8Cast(field, next) {
  const t = field.type;
  if (t === 'VAR_STRING' || t === 'STRING' || t === 'BLOB' ||
      t === 'TINY_BLOB' || t === 'MEDIUM_BLOB' || t === 'LONG_BLOB') {
    const buf = field.buffer();
    return buf ? buf.toString('utf8') : null;
  }
  return next();
}

export const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'maintenance-db',
  waitForConnections: true,
  connectionLimit: 10,
  dateStrings: true,
  typeCast: utf8Cast
});
