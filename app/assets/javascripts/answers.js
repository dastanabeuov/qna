//Edit answer render form
$(document).on('turbolinks:load', function(){
   $('.answers').on('click', '.edit-answer-link', function(e) {
       e.preventDefault();
       $(this).hide();
       var answerId = $(this).data('answerId');
       $('.answers form#edit-answer-' + answerId).removeClass('hidden');
   })
});
