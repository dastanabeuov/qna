$(document).on('turbolinks:load', function(){
  $('.voting').on('ajax:success', function(e){
      var xhr = e.detail[0];
      var resource = xhr['resource'];
      var id = xhr['id'];
      var vote_type = xhr['vote_type']
      var vote_count = xhr['vote_count'];

      $('#' + resource + '-' + id + ' .voting .vote_count').html(vote_count);

      var likeButton = $('#' + resource + '-' + id + ' .voting .like-button');
      var dislikeButton = $('#' + resource + '-' + id + ' .voting .dislike-button');

      likeButton.removeClass("liked");
      likeButton.removeClass("no-like");
      dislikeButton.removeClass("disliked");
      dislikeButton.removeClass("no-like");

      if(votetype == 'like'){
        likeButton.addClass("liked");
        dislikeButton.addClass("no-like");
      }
      else if (votetype == 'dislike'){
        dislikeButton.addClass("disliked");
        likeButton.addClass("no-like");
      }
  });
});