//Edit question render form
$(document).on('turbolinks:load', function(){
    $('.question').on('click', '.edit-question-link', function(e) {
        e.preventDefault();
        $(this).hide();
        var questionId = $(this).data('questionId');
        $('.question form#edit-question-' + questionId).removeClass('hidden');
    });
});