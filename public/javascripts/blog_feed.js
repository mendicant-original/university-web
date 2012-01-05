$(function() {
  $.jGFeed(
    "http://school.mendicantuniversity.org/changelog.rss",
    function(feed) {
      if(!feed) {
        return false;
      }

      $("#mendicant-news ul").empty();

      $(feed.entries).each(function(){
        $("#mendicant-news ul").append('<li><a target="_blank" href="'
                                + this.link + '">' + this.title + '</a></li>');
      });
    },

    10 // Number of posts to retrieve
  );

});
