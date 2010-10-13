$(function() {
  $.jGFeed(
    "http://blog.majesticseacreature.com/rss.xml?tag=rubymendicant",
    function(feed) {
      if(!feed) {
        return false;
      }
      
      $(".blog ul").empty();
      
      $(feed.entries).each(function(){
        $(".blog ul").append('<li><a href="' + this.link + '">' +
                             this.title + '</a></li>');
      });
    },
    
    5 // Number of posts to retrieve
  );
});
