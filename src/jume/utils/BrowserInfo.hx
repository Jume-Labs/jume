package jume.utils;

import js.Browser;

/**
 * The browser types.
 */
enum abstract BrowserType(String) {
  var CHROME = 'Chrome';
  var FIREFOX = 'Firefox';
  var IE = 'Internet Explorer';
  var SAFARI = 'Safari';
  var UNKNOWN = 'Unknown';
}

/**
 * Get the type fo the current browser.
 * @return The browser type.
 */
function getBrowser(): BrowserType {
  #if !headless
  final agent = Browser.navigator.userAgent;
  if (agent.indexOf('Safari') != -1 && agent.indexOf('Chrome') != -1) {
    return BrowserType.SAFARI;
  } else if (agent.indexOf('Chrome') != -1) {
    return BrowserType.CHROME;
  } else if (agent.indexOf('Firefox') != -1) {
    return BrowserType.FIREFOX;
  } else if (agent.indexOf('MSIE') != -1 || agent.indexOf('Trident/') != -1) {
    return BrowserType.IE;
  }
  #end

  return BrowserType.UNKNOWN;
}

/**
 * Check if the game is running in a mobile browser.
 * @returns True if the game is running in a mobile browser.
 */
function isMobile(): Bool {
  #if !headless
  final regex = ~/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i;

  return regex.match(Browser.navigator.userAgent);
  #end

  return false;
}
