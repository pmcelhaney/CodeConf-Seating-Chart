$(function () {

	var closeForm = function () {
		$('#mark-seat-form').fadeOut('slow');
		$('td').removeClass('selected');
			
	};


	$('#save').bind('click', function () {
		var value = $('#mark-seat-form input[name=status]:checked')[0].value;
		var seatId = $('#mark-seat-form input[name=seat-id]').val();
		if (value === 'twitter') {
			value = $('#mark-seat-form input[name=twitter-username]').val();
		}
		
		var url = '/update/'+seatId+'/mark/'+ value +'/';
		$.get(url, updateFromServer);
		//console.log(url);
		closeForm();
		return false;
	});

    $('#cancel').bind('click', function () {
		closeForm();
		return false;
	});
	
	$('#twitter-username').bind('focus', function () {
		$('#mark-seat-form input[name=status][value=twitter]').attr('checked', 'checked');
	});
	

	var markSeat = function(seat, seatId) {

		var taken = 'taken';
        var $seat = $(seat);
		var $form = $('#mark-seat-form');
		var position = $seat.position();
		
		$('td').removeClass('selected');
		$seat.addClass('selected');
		$('#mark-seat-form input[name=seat-id]').val(seatId);
		if ($seat.hasClass('filled')) {
			if ($seat.find('img').length) {
				$('#mark-seat-form input[name=status][value=twitter]').attr('checked', 'checked');
				$('#mark-seat-form input[name=twitter-username]').val($seat.find('img').attr('alt').replace('@', ''));
			} else {
				$('#mark-seat-form input[name=status][value=taken]').attr('checked', 'checked');				
			}
		} else {
			$('#mark-seat-form input[name=status][value=open]').attr('checked', 'checked');
		}
		
		
		$form.css({top: position.top + 60, left: leftPosition(position.left, $form.width()) }).fadeIn();
	};
	
	var leftPosition = function (left, width) {
		var leftBound = 20;
		var rightBound = $('body').width() - width - 20;
		return Math.max( Math.min(left - width / 2, rightBound), leftBound);
	};
	

	var rows = 17;
	var cols = 21;
	var i, j;
	var tr, td, data;


	for (i = 0; i < rows; i++) {
		tr = $('<tr></tr>');
		for (j = 0; j < cols; j++) {

            var seatId = 'seat-'+i+'-'+j;
			td = $('<td id="'+seatId+'"></td>');
			if (j === 10) {
				td.addClass('isle');
			} else {
                td.addClass('seat').click( (function (seatId) { return function () { if ( $(this).hasClass('selected') ) { closeForm(); } else { markSeat(this, seatId); }  }; }(seatId)) );
            }

			tr.append(td);
		}

		$('#openseats').append(tr);
	}





	var displayData = function (data) {
		var i, j;
		var td;
		for (i = 0; i < rows; i++) {
			for (j = 0; j < cols; j++) {
                var seatId = 'seat-'+i+'-'+j;
				td = $('#'+seatId);
                //if( seatId == 'seat-0-9' ){
                    //console.log(data[seatId]);
                //}
				if (data[seatId].taken) {
					td.addClass('filled');
                    if (data[seatId].twitter  && data[seatId].twitter != "taken") {
                        if (td.find('img').length === 0) {
                            //console.log(data[seatId].twitter);
                            td.append('<img>');
                        }
                        var imgSrc ='https://api.twitter.com/1/users/profile_image/' + data[seatId].twitter;
                        //console.log(imgSrc);
						td.find('img').attr({
                            'src': imgSrc,
                            'title': '@'+data[seatId].twitter,
                            'alt': '@'+data[seatId].twitter
                        }).css('opacity', .35).hover(function(){
                            $(this).css('opacity', 1);
                        }, function(){
                            $(this).css('opacity', .35);
                        });
					}
				} else {
					td.removeClass('filled').find('img').remove();
				}
			}

		}
	};

	var updateFromServer = function () {
		$.getJSON('/seats.json', function (d) { data = d; displayData(d); });
	};
	
	
	updateFromServer();
	setInterval( updateFromServer, 10000);

});

