//edit answer render form
$(document).on('turbolinks:load', function(){
   $('.answers').on('click', '.edit-answer-link', function(e) {
       e.preventDefault();
       $(this).hide();
       var answerId = $(this).data('answerId');
       console.log(answerId);
       $('section.answers form#edit-answer-' + answerId).removeClass('hidden');
   })
});

//correct answer choose
$(document).on('turbolinks:load', function(){
   $('.answers').on('click', '.correct-answer-link', function(e) {
       e.preventDefault();
       $(this).hide();
       var answerId = $(this).data('answerId');
       console.log(answerId);
       $('form#correct-answer-' + answerId).removeClass('hidden');
   })
});