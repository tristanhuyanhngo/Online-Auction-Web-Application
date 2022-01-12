import fn from 'knex';

export const connectionInfo = {
    host: '127.0.0.1',
    port: 3306,
    user: 'root',
    // password: '1234',
    database: 'online-auction'
    // host: 'us-cdbr-east-05.cleardb.net',
    // user: 'bb68f9aba0ba4f',
    // password: '18e21cf5',
    // database: 'heroku_b678196fa5bf427'
}

const knex = fn({
    client: 'mysql2',
    connection: connectionInfo,
    pool: { min: 0, max: 10 }
});

export default knex;