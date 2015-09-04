var express    = require('express')
  , Emitter    = require('primus-emitter')
  , Primus     = require('primus')
  , xmpp       = require('xmpp-ftw')
  , Buddycloud = require('xmpp-ftw-buddycloud')
<<<<<<< HEAD
=======
  , winston = require('winston');

var logger = new (winston.Logger)({
    transports: [
      new (winston.transports.File)({ 
        filename: '/var/log/xmpp-ftw/xmpp-ftw.log',
        handleExceptions: true,
	level: 'debug',
	json: false
      })
    ]
})
>>>>>>> f7f2029bf9c65699c35e2d32ffe21d70422844cb

var app = express()

app.get('/', function(req, res){
    res.render('index')
})

var server = app.listen(6000, function() {
<<<<<<< HEAD
    console.log('Listening on port %d', server.address().port)
=======
    logger.info('Listening on port %d', server.address().port)
>>>>>>> f7f2029bf9c65699c35e2d32ffe21d70422844cb
})

app.configure(function() {
    app.use(express.static(__dirname + '/public'))
    app.use(express.bodyParser())
    app.use(express.methodOverride())
<<<<<<< HEAD
    app.use(express.logger)
=======
    app.use(logger)
>>>>>>> f7f2029bf9c65699c35e2d32ffe21d70422844cb
    app.use(express.errorHandler({
        dumpExceptions: true,
        showStack: true
    }))
})

var options = {
    transformer: 'socket.io',
    parser: 'JSON',
    transports: [
        'websocket',
        'htmlfile',
        'xhr-polling',
        'jsonp-polling'
    ],
}

var primus = new Primus(server, options)
primus.use('emitter', Emitter)
primus.save(__dirname + '/public/scripts/primus/primus.js')

primus.on('connection', function(socket) {
<<<<<<< HEAD
    console.log('Websocket connection made')
=======
    logger.info('Websocket connection made')
>>>>>>> f7f2029bf9c65699c35e2d32ffe21d70422844cb
    var xmppFtw = new xmpp.Xmpp(socket)
    xmppFtw.addListener(new Buddycloud())
    socket.xmppFtw = xmppFtw
})

primus.on('disconnection', function(socket) {
<<<<<<< HEAD
    console.log('Client disconnected, logging them out')
    try {
        socket.xmppFtw.logout()
    } catch (e) {
        console.log(e)
=======
    logger.info('Client disconnected, logging them out')
    try {
        socket.xmppFtw.logout()
    } catch (e) {
        logger.error(e)
>>>>>>> f7f2029bf9c65699c35e2d32ffe21d70422844cb
    }
})
