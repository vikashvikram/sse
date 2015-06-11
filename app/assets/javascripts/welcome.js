window.onload = function() {
	var messageList = document.getElementById('message-list');

	if (messageList != null) {
		var source = new EventSource('/event');

		source.addEventListener('message', function(e){
		  var messages = $.parseJSON(e.data);
		  for (i in messages) {
		  	$("#message-list").append("<li>"+ messages[i].body +"</li>");
		  }
		}, false);

		source.addEventListener('finished', function(e){
		  console.log('Close:', e.data);
		  source.close();
		});

		source.onopen = function() {
			//alert("connected");
		};

		document.addEventListener("page:load", function(){
		  alert("hello");
		});
	}
}

