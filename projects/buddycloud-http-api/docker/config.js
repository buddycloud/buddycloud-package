exports._ = {
  port: 9123,
};

// Production settings
exports.production = {
  debug: true,
  xmppHost: '127.0.0.1',
  channelDomain: 'channels.buddycloud.net',
  pusherComponent: 'pusher.buddycloud.com',
  friendFinderComponent: 'friend-finder.buddycloud.com',
  searchComponent: 'search.buddycloud.org',
  homeMediaRoot: '#MEDIA_SERVER_ADDRESS',
};

