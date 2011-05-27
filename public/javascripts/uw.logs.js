// UW.Logs

UW.setupNamespace("Logs");

UW.Logs.init = function(options){
  this.lastMessageRecordedAt = options.lastMessageRecordedAt;
  this.lastMessageId         = options.lastMessageId;
  this.url                   = options.url;
  this.channel               = options.channel;
  this.topic                 = options.topic;

  $.scrollTo('#bottom', { axis: 'y' });

  setTimeout(this.loadMessages, 3000);
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
          $.scrollTo('table.messages tr:last', { axis: 'y' });
      }
    },
    error: UW.Logs.loadMessagesError,
    complete: function() {
      setTimeout(UW.Logs.loadMessages, 3000);
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