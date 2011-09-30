// UW.Logs

UW.setupNamespace("Logs");

UW.Logs.init = function(options){
  this.lastMessageRecordedAt = options.lastMessageRecordedAt;
  this.lastMessageId         = options.lastMessageId;
  this.url                   = options.url;
  this.channel               = options.channel;
  this.topic                 = options.topic;
  this.refreshInterval       = options.refreshInterval || 60 * 60 * 1000;
  this.startedTime           = new Date;
  this.loadMessagesOnScroll  = options.loadMessagesOnScroll || false;
  this.offset                = 0;

  $.scrollTo('#bottom', { axis: 'y' });
  $('#messages_container').scrollTo('#bottom', { axis: 'y' });

  setTimeout(this.loadMessages, 3000);

  if (this.loadMessagesOnScroll) {
    $('#messages_container').bind('scroll', this.loadPreviousMessages);
  }
}

UW.Logs.loadMessages = function(){
  $.ajax({
    url: UW.Logs.url,
    dataType: 'json',
    data: {
      channel:  UW.Logs.channel,
      since:    UW.Logs.lastMessageRecordedAt,
      last_id:  UW.Logs.lastMessageId,
      topic:    UW.Logs.topic
    },
    success: function(data){
      if(!(data instanceof Array)) {
        UW.Logs.loadMessagesError();
        return;
      }

      $("#flash > .flash").slideUp(function(){ $(this).remove(); });

      if(data.length > 0){
        UW.Logs.lastMessageRecordedAt = data[data.length - 1].recorded_at;
        UW.Logs.lastMessageId         = data[data.length - 1].id;

        var scrollToMessage = isScrollBottom();

        for(var x = 0; x <= data.length - 1; x++){
          $('table.messages tr:last').after(data[x].html);
        }

        if(scrollToMessage == true)
          $('#messages_container').scrollTo('table.messages tr:last', { axis: 'y' });
      }
    },
    error: UW.Logs.loadMessagesError,
    complete: function() {
      if (UW.Logs.continueToLoadMessages()) {
        setTimeout(UW.Logs.loadMessages, 3000);
      } else {
        UW.Logs.displayStoppedRefreshMessage();
      }
    }
  });
}

UW.Logs.loadMessagesError = function(){
  if($("#flash > .flash.error").length === 0) {
    var errorMessage = "Error communicating with the server",
      error = $("<div/>", {
        "class": "flash error",
        text:    errorMessage,
        style:   "display: none;"
      });

    $("#flash").append(error);
    $("#flash > .flash:hidden").slideDown();
  }
}

UW.Logs.continueToLoadMessages = function(){
  var elapsedTime = (new Date) - this.startedTime;

  return elapsedTime < this.refreshInterval;
}

UW.Logs.displayStoppedRefreshMessage = function(){
  var message = "Autoloading of messages is stopped after an hour",
    error = $("<div/>", {
      "class": "flash notice",
      text:    message,
      style:   "display: none;"
    });

  $("#flash").append(error);
  $("#flash > .flash:hidden").slideDown();

  $.scrollTo('#flash', { axis: 'y' });
}

UW.Logs.loadPreviousMessages = function(){
  var doc = $('#messages_container');

  if (doc.scrollTop() > 200) return;

  doc.unbind('scroll', UW.Logs.loadPreviousMessages);

  UW.Logs.offset += 1;

  $.ajax({
    url: UW.Logs.url,
    dataType: 'json',
    data: {
      channel:  UW.Logs.channel,
      topic:    UW.Logs.topic,
      offset:   UW.Logs.offset
    },
    success: function(data){
      if(!(data instanceof Array)) {
        UW.Logs.loadMessagesError();
        return;
      }

      if (data.length > 0) {
        var container = $('<div></div>');

        for (var x = 0; x < data.length; x++) {
          container.append(data[x].html);
        }
        container.find('tr:last').attr('id', 'last-message');

        $('table.messages tr.date:first').replaceWith(container.html());
        doc.scrollTo('#last-message', { axis: 'y' });
        $('#last-message').attr('id', null);

        doc.bind('scroll', UW.Logs.loadPreviousMessages);
      }
    },
    error: UW.Logs.loadMessagesError
  });
}
