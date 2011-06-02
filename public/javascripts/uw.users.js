UW.setupNamespace("Users");

UW.Users.init = function(usersPath) {
  $('#github-repositories li').click(function() {
      window.location.href = $(this).find("a").attr("href");
  });
}
