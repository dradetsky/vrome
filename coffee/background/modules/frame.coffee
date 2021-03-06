class window.Frame
  currentFrameUrls = {}

  nextUrl = (frames, currentFrameUrl, count) ->
    frameUrls    = (frame.url for frame in frames when frame.url not in ['doubleclick.', 'qzone.qq.com', 'plusone.google.com', 'about:blank'])
    uniqueUrls   = $.unique(frameUrls).reverse()
    currentIndex = uniqueUrls.indexOf currentFrameUrl
    newIndex     = (currentIndex + count) %% uniqueUrls.length
    uniqueUrls[newIndex]

  @next: (msg) ->
    chrome.webNavigation.getAllFrames tabId: msg.tab.id, (frames) ->
      currentFrameUrls[msg.tab.id] = nextUrl(frames, currentFrameUrls[msg.tab.id], msg.count)
      Post msg.tab, action: 'Frame.select', href: currentFrameUrls[msg.tab.id]
