exports._ = {
  port: 9123,
};

// Production settings
exports.production = {
  debug: true,
  channelDomain: 'cs.buddycloud.net',
  xmppAnonymousDomain: 'anon.buddycloud.net',
  pusherComponent: 'pusher.buddycloud.com',
  friendFinderComponent: 'friend-finder.buddycloud.com',
  searchComponent: 'search.buddycloud.org',
  homeMediaRoot: 'http://si.buddycloud.com:60080',
  createUserOnSessionCreation: true,
  logTransport: 'file',
  logFile: '/var/log/buddycloud-http-api/buddycloud-http-api.log',
  logLevel: 'debug',
  logUseJson: false
};

