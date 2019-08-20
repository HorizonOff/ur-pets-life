$( document ).on('turbolinks:load', function() {
  if ($('#messages').length > 0) {
    $('[data-channel-subscribe="room"]').each(function(index, element) {
      var $element = $(element),
      messageTemplate = $('[data-role="message-template"]');
      var height = $element[0].scrollHeight;
      $element.scrollTop(height);
      App.messages = App.cable.subscriptions.create({
        channel: 'ChatMessagesChannel',
        chat_id: $('#messages').data('support-chat-id') }, {
        // Called when there's incoming data
        //on the websocket for this channel.
        received: function(data) {
          console.log(data.chat_message.text);
          var content = messageTemplate.children().clone(true, true);
          content.find('.message-content').addClass(data.chat_message.m_type);
          content.find('[data-role="message-text"]').text(data.chat_message.text);
          content.find('[data-role="message-date"]').text(data.chat_message.timestamp);
          $('#messages-pool').append(content);
          var height = $element[0].scrollHeight;
          $element.scrollTop(height);
        },
      });
    });
  };
})
