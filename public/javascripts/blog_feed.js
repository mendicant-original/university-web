$(function() {
  $.jGFeed(
    "http://blog.majesticseacreature.com/rss.xml?tag=rubymendicant",
    function(feed) {
      if(!feed) {
        return false;
      }
      
      $("#majestic_blog ul").empty();
      
      $(feed.entries).each(function(){
        $("#majestic_blog ul").append('<li><a target="_blank" href="'
                                + this.link + '">' + this.title + '</a></li>');
      });
    },
    
    5 // Number of posts to retrieve
  );
  
  function split_slug(slug) {
    var text = "";
    var split = slug.split("-");
    
    for(var i in split) {
      text += " " + split[i];
    };
    
    return text;
  };
  
  $.getJSON( "http://educationreimagined.tumblr.com/api/read/json?num=5&callback=?",
    function(data) {
      $("#learning_blog ul").empty();
      
      $.each(data.posts, function(i, post) {
        var title = "";
        
        switch(post.type) {
          case "regular":
            title = "post: " + post["regular-title"];
            break;
          default:
            title = post.type + ": " + split_slug(post.slug);
            break;
        };
        
        $("#learning_blog ul").append('<li><a target="_blank" href="'
                        + post.url_with_slug + '">' + title + '</a></li>');
      });
  });
  
});
