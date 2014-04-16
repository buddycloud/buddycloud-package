var express    = require('express')
  , Emitter    = require('primus-emitter')
  , Primus     = require('primus')
  , xmpp       = require('xmpp-ftw')
  , Buddycloud = require('xmpp-ftw-buddycloud')

var app = express()

app.get('/', function(req, res){
    res.render('index')
})

var server = app.listen(6000, function() {
    console.log('Listening on port %d', server.address().port)
})

app.configure(function() {
    app.use(express.static(__dirname + '/public'))
    app.use(express.bodyParser())
    app.use(express.methodOverride())
    app.use(express.logger)
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
    ]
}

var primus = new Primus(server, options)
primus.use('emitter', Emitter)
primus.save(__dirname + '/public/scripts/primus.js')

primus.on('connection', function(socket) {
    console.log('Websocket connection made')
    var xmppFtw = new xmpp.Xmpp(socket)
    xmppFtw.addListener(new Buddycloud())
    socket.xmppFtw = xmppFtw
})

primus.on('disconnection', function(socket) {
    console.log('Client disconnected, logging them out')
    socket.xmppFtw.logout()
})
