# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.question').on 'click', '.edit-question-link', (e) ->
    e.preventDefault();
    $(this).hide();
    $('form.edit_question').show();

  $('.vote_link').on 'ajax:success', (e) ->
    response = e.detail[0];
    rating = $('.question_rating').find('.rating');
    rating.html(response.rating);

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      $('.questions_list').append data
  });

$(document).on('turbolinks:load', ready);