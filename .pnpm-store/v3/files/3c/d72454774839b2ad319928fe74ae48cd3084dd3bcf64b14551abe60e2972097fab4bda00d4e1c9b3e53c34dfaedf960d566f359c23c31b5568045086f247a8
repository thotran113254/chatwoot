'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

function _interopDefault (ex) { return (ex && (typeof ex === 'object') && 'default' in ex) ? ex['default'] : ex; }

var isToday = _interopDefault(require('date-fns/isToday'));
var isYesterday = _interopDefault(require('date-fns/isYesterday'));

// Returns a function, that, as long as it continues to be invoked, will not
// be triggered. The function will be called after it stops being called for
// N milliseconds. If `immediate` is passed, trigger the function on the
// leading edge, instead of the trailing.

/**
 * @func Callback function to be called after delay
 * @delay Delay for debounce in ms
 * @immediate should execute immediately
 * @returns debounced callback function
 */
var debounce = function debounce(func, wait, immediate) {
  var timeout;
  return function () {
    var context = null;
    var args = arguments;

    var later = function later() {
      timeout = null;
      if (!immediate) func.apply(context, args);
    };

    var callNow = immediate && !timeout;
    clearTimeout(timeout);
    timeout = window.setTimeout(later, wait);
    if (callNow) func.apply(context, args);
  };
};

/**
 * @name Get contrasting text color
 * @description Get contrasting text color from a text color
 * @param bgColor  Background color of text.
 * @returns contrasting text color
 */

var getContrastingTextColor = function getContrastingTextColor(bgColor) {
  var color = bgColor.replace('#', '');
  var r = parseInt(color.slice(0, 2), 16);
  var g = parseInt(color.slice(2, 4), 16);
  var b = parseInt(color.slice(4, 6), 16); // http://stackoverflow.com/a/3943023/112731

  return r * 0.299 + g * 0.587 + b * 0.114 > 186 ? '#000000' : '#FFFFFF';
};
/**
 * @name Get formatted date
 * @description Get date in today, yesterday or any other date format
 * @param date  date
 * @param todayText  Today text
 * @param yesterdayText  Yesterday text
 * @returns formatted date
 */

var formatDate = function formatDate(_ref) {
  var date = _ref.date,
      todayText = _ref.todayText,
      yesterdayText = _ref.yesterdayText;
  var dateValue = new Date(date);
  if (isToday(dateValue)) return todayText;
  if (isYesterday(dateValue)) return yesterdayText;
  return date;
};
/**
 * @name formatTime
 * @description Format time to Hour, Minute and Second
 * @param timeInSeconds  number
 * @returns formatted time
 */

var formatTime = function formatTime(timeInSeconds) {
  var formattedTime = '';

  if (timeInSeconds >= 60 && timeInSeconds < 3600) {
    var minutes = Math.floor(timeInSeconds / 60);
    formattedTime = minutes + " Min";
    var seconds = minutes === 60 ? 0 : Math.floor(timeInSeconds % 60);
    return formattedTime + ("" + (seconds > 0 ? ' ' + seconds + ' Sec' : ''));
  }

  if (timeInSeconds >= 3600 && timeInSeconds < 86400) {
    var hours = Math.floor(timeInSeconds / 3600);
    formattedTime = hours + " Hr";

    var _minutes = timeInSeconds % 3600 < 60 || hours === 24 ? 0 : Math.floor(timeInSeconds % 3600 / 60);

    return formattedTime + ("" + (_minutes > 0 ? ' ' + _minutes + ' Min' : ''));
  }

  if (timeInSeconds >= 86400) {
    var days = Math.floor(timeInSeconds / 86400);
    formattedTime = days + " Day";

    var _hours = timeInSeconds % 86400 < 3600 || days >= 364 ? 0 : Math.floor(timeInSeconds % 86400 / 3600);

    return formattedTime + ("" + (_hours > 0 ? ' ' + _hours + ' Hr' : ''));
  }

  return Math.floor(timeInSeconds) + " Sec";
};
/**
 * @name trimContent
 * @description Trim a string to max length
 * @param content String to trim
 * @param maxLength Length of the string to trim, default 1024
 * @param ellipsis Boolean to add dots at the end of the string, default false
 * @returns trimmed string
 */

var trimContent = function trimContent(content, maxLength, ellipsis) {
  if (content === void 0) {
    content = '';
  }

  if (maxLength === void 0) {
    maxLength = 1024;
  }

  if (ellipsis === void 0) {
    ellipsis = false;
  }

  var trimmedContent = content;

  if (content.length > maxLength) {
    trimmedContent = content.substring(0, maxLength);
  }

  if (ellipsis) {
    trimmedContent = trimmedContent + '...';
  }

  return trimmedContent;
};
/**
 * @name convertSecondsToTimeUnit
 * @description Convert seconds to time unit
 * @param seconds  number
 * @param unitNames  object
 * @returns time and unit
 * @example
 * convertToUnit(60, { minute: 'm', hour: 'h', day: 'd' }); // { time: 1, unit: 'm' }
 * convertToUnit(60, { minute: 'Minutes', hour: 'Hours', day: 'Days' }); // { time: 1, unit: 'Minutes' }
 */

var convertSecondsToTimeUnit = function convertSecondsToTimeUnit(seconds, unitNames) {
  if (seconds === null || seconds === 0) return {
    time: '',
    unit: ''
  };
  if (seconds < 3600) return {
    time: Number((seconds / 60).toFixed(1)),
    unit: unitNames.minute
  };
  if (seconds < 86400) return {
    time: Number((seconds / 3600).toFixed(1)),
    unit: unitNames.hour
  };
  return {
    time: Number((seconds / 86400).toFixed(1)),
    unit: unitNames.day
  };
};

/**
 * Function that parses a string boolean value and returns the corresponding boolean value
 * @param {string | number} candidate - The string boolean value to be parsed
 * @return {boolean} - The parsed boolean value
 */
function parseBoolean(candidate) {
  try {
    // lowercase the string, so TRUE becomes true
    var candidateString = String(candidate).toLowerCase(); // wrap in boolean to ensure that the return value
    // is a boolean even if values like 0 or 1 are passed

    return Boolean(JSON.parse(candidateString));
  } catch (error) {
    return false;
  }
}

/**
 * Sorts an array of numbers in ascending order.
 * @param {number[]} arr - The array of numbers to be sorted.
 * @returns {number[]} - The sorted array.
 */
function sortAsc(arr) {
  // .slice() is used to create a copy of the array so that the original array is not mutated
  return arr.slice().sort(function (a, b) {
    return a - b;
  });
}
/**
 * Calculates the quantile value of an array at a specified percentile.
 * @param {number[]} arr - The array of numbers to calculate the quantile value from.
 * @param {number} q - The percentile to calculate the quantile value for.
 * @returns {number} - The quantile value.
 */

function quantile(arr, q) {
  var sorted = sortAsc(arr); // Sort the array in ascending order

  return _quantileForSorted(sorted, q); // Calculate the quantile value
}
/**
 * Clamps a value between a minimum and maximum range.
 * @param {number} min - The minimum range.
 * @param {number} max - The maximum range.
 * @param {number} value - The value to be clamped.
 * @returns {number} - The clamped value.
 */

function clamp(min, max, value) {
  if (value < min) {
    return min;
  }

  if (value > max) {
    return max;
  }

  return value;
}
/**
 * This method assumes the the array provided is already sorted in ascending order.
 * It's a helper method for the quantile method and should not be exported as is.
 *
 * @param {number[]} arr - The array of numbers to calculate the quantile value from.
 * @param {number} q - The percentile to calculate the quantile value for.
 * @returns {number} - The quantile value.
 */

function _quantileForSorted(sorted, q) {
  var clamped = clamp(0, 1, q); // Clamp the percentile between 0 and 1

  var pos = (sorted.length - 1) * clamped; // Calculate the index of the element at the specified percentile

  var base = Math.floor(pos); // Find the index of the closest element to the specified percentile

  var rest = pos - base; // Calculate the decimal value between the closest elements
  // Interpolate the quantile value between the closest elements
  // Most libraries don't to the interpolation, but I'm just having fun here
  // also see https://en.wikipedia.org/wiki/Quantile#Estimating_quantiles_from_a_sample

  if (sorted[base + 1] !== undefined) {
    // in case the position was a integer, the rest will be 0 and the interpolation will be skipped
    return sorted[base] + rest * (sorted[base + 1] - sorted[base]);
  } // Return the closest element if there is no interpolation possible


  return sorted[base];
}
/**
 * Calculates the quantile values for an array of intervals.
 * @param {number[]} data - The array of numbers to calculate the quantile values from.
 * @param {number[]} intervals - The array of intervals to calculate the quantile values for.
 * @returns {number[]} - The array of quantile values for the intervals.
 */


var getQuantileIntervals = function getQuantileIntervals(data, intervals) {
  // Sort the array in ascending order before looping through the intervals.
  // depending on the size of the array and the number of intervals, this can speed up the process by at least twice
  // for a random array of 100 numbers and 5 intervals, the speedup is 3x
  var sorted = sortAsc(data);
  return intervals.map(function (interval) {
    return _quantileForSorted(sorted, interval);
  });
};

function _extends() {
  _extends = Object.assign || function (target) {
    for (var i = 1; i < arguments.length; i++) {
      var source = arguments[i];

      for (var key in source) {
        if (Object.prototype.hasOwnProperty.call(source, key)) {
          target[key] = source[key];
        }
      }
    }

    return target;
  };

  return _extends.apply(this, arguments);
}

var MESSAGE_VARIABLES_REGEX = /{{(.*?)}}/g;

var skipCodeBlocks = function skipCodeBlocks(str) {
  return str.replace(/```(?:.|\n)+?```/g, '');
};

var capitalizeName = function capitalizeName(name) {
  return (name || '').replace(/\b(\w)/g, function (s) {
    return s.toUpperCase();
  });
};
var getFirstName = function getFirstName(_ref) {
  var user = _ref.user;
  var firstName = user != null && user.name ? user.name.split(' ').shift() : '';
  return capitalizeName(firstName);
};
var getLastName = function getLastName(_ref2) {
  var user = _ref2.user;

  if (user && user.name) {
    var lastName = user.name.split(' ').length > 1 ? user.name.split(' ').pop() : '';
    return capitalizeName(lastName);
  }

  return '';
};
var getMessageVariables = function getMessageVariables(_ref3) {
  var _assignee$email;

  var conversation = _ref3.conversation,
      contact = _ref3.contact;
  var _conversation$meta = conversation.meta,
      assignee = _conversation$meta.assignee,
      sender = _conversation$meta.sender,
      id = conversation.id,
      _conversation$custom_ = conversation.custom_attributes,
      conversationCustomAttributes = _conversation$custom_ === void 0 ? {} : _conversation$custom_;

  var _ref4 = contact || {},
      contactCustomAttributes = _ref4.custom_attributes;

  var standardVariables = {
    'contact.name': capitalizeName((sender == null ? void 0 : sender.name) || ''),
    'contact.first_name': getFirstName({
      user: sender
    }),
    'contact.last_name': getLastName({
      user: sender
    }),
    'contact.email': sender == null ? void 0 : sender.email,
    'contact.phone': sender == null ? void 0 : sender.phone_number,
    'contact.id': sender == null ? void 0 : sender.id,
    'conversation.id': id,
    'agent.name': capitalizeName((assignee == null ? void 0 : assignee.name) || ''),
    'agent.first_name': getFirstName({
      user: assignee
    }),
    'agent.last_name': getLastName({
      user: assignee
    }),
    'agent.email': (_assignee$email = assignee == null ? void 0 : assignee.email) != null ? _assignee$email : ''
  };
  var conversationCustomAttributeVariables = Object.entries(conversationCustomAttributes != null ? conversationCustomAttributes : {}).reduce(function (acc, _ref5) {
    var key = _ref5[0],
        value = _ref5[1];
    acc["conversation.custom_attribute." + key] = value;
    return acc;
  }, {});
  var contactCustomAttributeVariables = Object.entries(contactCustomAttributes != null ? contactCustomAttributes : {}).reduce(function (acc, _ref6) {
    var key = _ref6[0],
        value = _ref6[1];
    acc["contact.custom_attribute." + key] = value;
    return acc;
  }, {});

  var variables = _extends({}, standardVariables, conversationCustomAttributeVariables, contactCustomAttributeVariables);

  return variables;
};
var replaceVariablesInMessage = function replaceVariablesInMessage(_ref7) {
  var message = _ref7.message,
      variables = _ref7.variables;
  // @ts-ignore
  return message == null ? void 0 : message.replace(MESSAGE_VARIABLES_REGEX, function (_, replace) {
    return variables[replace.trim()] ? variables[replace.trim().toLowerCase()] : '';
  });
};
var getUndefinedVariablesInMessage = function getUndefinedVariablesInMessage(_ref8) {
  var message = _ref8.message,
      variables = _ref8.variables;
  var messageWithOutCodeBlocks = skipCodeBlocks(message);
  var matches = messageWithOutCodeBlocks.match(MESSAGE_VARIABLES_REGEX);
  if (!matches) return [];
  return matches.map(function (match) {
    return match.replace('{{', '').replace('}}', '').trim();
  }).filter(function (variable) {
    return variables[variable] === undefined;
  });
};

/**
 * Creates a typing indicator utility.
 * @param onStartTyping Callback function to be called when typing starts
 * @param onStopTyping Callback function to be called when typing stops after delay
 * @param idleTime Delay for idle time in ms before considering typing stopped
 * @returns An object with start and stop methods for typing indicator
 */
var createTypingIndicator = function createTypingIndicator(onStartTyping, onStopTyping, idleTime) {
  var timer = null;

  var start = function start() {
    if (!timer) {
      onStartTyping();
    }

    reset();
  };

  var stop = function stop() {
    if (timer) {
      clearTimeout(timer);
      timer = null;
      onStopTyping();
    }
  };

  var reset = function reset() {
    if (timer) {
      clearTimeout(timer);
    }

    timer = setTimeout(function () {
      stop();
    }, idleTime);
  };

  return {
    start: start,
    stop: stop
  };
};

/**
 * Calculates the threshold for an SLA based on the current time and the provided threshold.
 * @param timeOffset - The time offset in seconds.
 * @param threshold - The threshold in seconds or null if not applicable.
 * @returns The calculated threshold in seconds or null if the threshold is null.
 */
var calculateThreshold = function calculateThreshold(timeOffset, threshold) {
  // Calculate the time left for the SLA to breach or the time since the SLA has missed
  if (threshold === null) return null;
  var currentTime = Math.floor(Date.now() / 1000);
  return timeOffset + threshold - currentTime;
};
/**
 * Finds the most urgent SLA status based on the threshold.
 * @param SLAStatuses - An array of SLAStatus objects.
 * @returns The most urgent SLAStatus object.
 */


var findMostUrgentSLAStatus = function findMostUrgentSLAStatus(SLAStatuses) {
  // Sort the SLAs based on the threshold and return the most urgent SLA
  SLAStatuses.sort(function (sla1, sla2) {
    return Math.abs(sla1.threshold) - Math.abs(sla2.threshold);
  });
  return SLAStatuses[0];
};
/**
 * Formats the SLA time in a human-readable format.
 * @param seconds - The time in seconds.
 * @returns A formatted string representing the time.
 */


var formatSLATime = function formatSLATime(seconds) {
  var units = {
    y: 31536000,
    mo: 2592000,
    d: 86400,
    h: 3600,
    m: 60
  };

  if (seconds < 60) {
    return '1m';
  } // we will only show two parts, two max granularity's, h-m, y-d, d-h, m, but no seconds


  var parts = [];
  Object.keys(units).forEach(function (unit) {
    var value = Math.floor(seconds / units[unit]);
    if (seconds < 60 && parts.length > 0) return;
    if (parts.length === 2) return;

    if (value > 0) {
      parts.push(value + unit);
      seconds -= value * units[unit];
    }
  });
  return parts.join(' ');
};
/**
 * Creates an SLA object based on the type, applied SLA, and chat details.
 * @param type - The type of SLA (FRT, NRT, RT).
 * @param appliedSla - The applied SLA details.
 * @param chat - The chat details.
 * @returns An object containing the SLA status or null if conditions are not met.
 */


var createSLAObject = function createSLAObject(type, appliedSla, chat) {
  var frtThreshold = appliedSla.sla_first_response_time_threshold,
      nrtThreshold = appliedSla.sla_next_response_time_threshold,
      rtThreshold = appliedSla.sla_resolution_time_threshold,
      createdAt = appliedSla.created_at;
  var firstReplyCreatedAt = chat.first_reply_created_at,
      waitingSince = chat.waiting_since,
      status = chat.status;
  var SLATypes = {
    FRT: {
      threshold: calculateThreshold(createdAt, frtThreshold),
      //   Check FRT only if threshold is not null and first reply hasn't been made
      condition: frtThreshold !== null && (!firstReplyCreatedAt || firstReplyCreatedAt === 0)
    },
    NRT: {
      threshold: calculateThreshold(waitingSince, nrtThreshold),
      // Check NRT only if threshold is not null, first reply has been made and we are waiting since
      condition: nrtThreshold !== null && !!firstReplyCreatedAt && !!waitingSince
    },
    RT: {
      threshold: calculateThreshold(createdAt, rtThreshold),
      // Check RT only if the conversation is open and threshold is not null
      condition: status === 'open' && rtThreshold !== null
    }
  };
  var SLAStatus = SLATypes[type];
  return SLAStatus ? _extends({}, SLAStatus, {
    type: type
  }) : null;
};
/**
 * Evaluates SLA conditions and returns an array of SLAStatus objects.
 * @param appliedSla - The applied SLA details.
 * @param chat - The chat details.
 * @returns An array of SLAStatus objects.
 */


var evaluateSLAConditions = function evaluateSLAConditions(appliedSla, chat) {
  // Filter out the SLA based on conditions and update the object with the breach status(icon, isSlaMissed)
  var SLATypes = ['FRT', 'NRT', 'RT'];
  return SLATypes.map(function (type) {
    return createSLAObject(type, appliedSla, chat);
  }).filter(function (SLAStatus) {
    return !!SLAStatus && SLAStatus.condition;
  }).map(function (SLAStatus) {
    return _extends({}, SLAStatus, {
      icon: SLAStatus.threshold <= 0 ? 'flame' : 'alarm',
      isSlaMissed: SLAStatus.threshold <= 0
    });
  });
};
/**
 * Evaluates the SLA status for a given chat and applied SLA.
 * @param {Object} params - The parameters object.
 * @param params.appliedSla - The applied SLA details.
 * @param params.chat - The chat details.
 * @returns An object containing the most urgent SLA status.
 */


var evaluateSLAStatus = function evaluateSLAStatus(_ref) {
  var appliedSla = _ref.appliedSla,
      chat = _ref.chat;
  if (!appliedSla || !chat) return {
    type: '',
    threshold: '',
    icon: '',
    isSlaMissed: false
  }; // Filter out the SLA and create the object for each breach

  var SLAStatuses = evaluateSLAConditions(appliedSla, chat); // Return the most urgent SLA which is latest to breach or has missed

  var mostUrgent = findMostUrgentSLAStatus(SLAStatuses);
  return mostUrgent ? {
    type: mostUrgent == null ? void 0 : mostUrgent.type,
    threshold: formatSLATime(mostUrgent.threshold <= 0 ? -mostUrgent.threshold : mostUrgent.threshold),
    icon: mostUrgent.icon,
    isSlaMissed: mostUrgent.isSlaMissed
  } : {
    type: '',
    threshold: '',
    icon: '',
    isSlaMissed: false
  };
};

exports.clamp = clamp;
exports.convertSecondsToTimeUnit = convertSecondsToTimeUnit;
exports.createTypingIndicator = createTypingIndicator;
exports.debounce = debounce;
exports.evaluateSLAStatus = evaluateSLAStatus;
exports.formatDate = formatDate;
exports.formatTime = formatTime;
exports.getContrastingTextColor = getContrastingTextColor;
exports.getMessageVariables = getMessageVariables;
exports.getQuantileIntervals = getQuantileIntervals;
exports.getUndefinedVariablesInMessage = getUndefinedVariablesInMessage;
exports.parseBoolean = parseBoolean;
exports.quantile = quantile;
exports.replaceVariablesInMessage = replaceVariablesInMessage;
exports.sortAsc = sortAsc;
exports.trimContent = trimContent;
//# sourceMappingURL=utils.cjs.development.js.map
