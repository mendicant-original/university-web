// UW.Timezones

if (typeof UW == 'undefined') {
  UW = {};
}
if (typeof UW.Timezones == 'undefined') {
  UW.Timezones = {};
}

UW.Timezones.init = function() {
	UW.Timezones.updateTimes();
    setInterval(UW.Timezones.updateTimes, 60000);
}

UW.Timezones.zeropad = function(num) {
  return num < 10 ? '0'+num : num;	
}

UW.Timezones.formatDate = function(d) {
  var localDate = new Date();
  var dateOutput = "- ";
  
  if(localDate.toDateString() != d.toDateString())
    dateOutput += d.toDateString() + ', ';
  
  dateOutput += UW.Timezones.zeropad(d.getHours()) + ':' + 
    UW.Timezones.zeropad(d.getMinutes());
    
  return dateOutput;
}

UW.Timezones.updateTimes = function() {
  var d = new Date();
  var utc_time = d.getTime()+(d.getTimezoneOffset()*60000);
  $('.timezone').each(function(i) {
    var offset = parseInt($(this).attr('data-utc-offset'));
    var zonetime = new Date(utc_time + (offset*1000));
    $(this).children('.time-display').text(UW.Timezones.formatDate(zonetime));
  });
}
