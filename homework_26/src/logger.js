const winston = require('winston');
const fluentLogger = require('fluent-logger');

const fluentTransport = fluentLogger.createFluentSender('js_app', {
    host: '192.168.33.3', // Issue with localhost on MacBook

    // We can run this in the same network as EFK stack
    // docker run --name node_app --network dan-it_hw_26_default -p 10000:10000 -e PORT=10000 node_app:1.0.1
    // host: 'fluentd',

    // host: 'localhost',
    port: 24224,
    timeout: 3.0
});

const logger = winston.createLogger({
    level: 'info',
    transports: [new winston.transports.Console()]
});

logger.on('data', (log) => {
    fluentTransport.emit('winston', {
        level: log.level,
        message: log.message,
        meta: log.meta || {},
        timestamp: new Date().toISOString()
    });
});

module.exports = logger;

