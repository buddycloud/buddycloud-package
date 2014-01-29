exports._ = {
  port: 9123,
};

// Production settings
exports.production = {
  debug: true,
  xmppHost: '#TIGASE_HOST#',
  channelDomain: 'channels.buddycloud.net',
  pusherComponent: 'pusher.buddycloud.com',
  friendFinderComponent: 'friend-finder.buddycloud.com',
  searchComponent: 'search.buddycloud.org',
  homeMediaRoot: 'http://#MEDIA_HOST#:60080',
};

