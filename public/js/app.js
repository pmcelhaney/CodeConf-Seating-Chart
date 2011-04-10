$(function () {

	$('#twitter-username').bind('focus', function () {
		$('#mark-seat-form input[name=status][value=twitter]').attr('checked', 'checked');
	});
	
	
	$('#mark-seat-form button').bind('click', function () {
		var value = $('#mark-seat-form input[name=status]:checked')[0].value;
		var row = $('#mark-seat-form input[name=row]').val();
		var col = $('#mark-seat-form input[name=col]').val();
		if (value === 'twitter') {
			value = $('#mark-seat-form input[name=twitter-username]').val();
		}
		
		var url = '/update/row/'+row+'/col/'+col+'/mark/'+ value +'/';
		$.get(url, updateFromServer);
		console.log(url);
		$('#mark-seat-form').slideUp('slow');
		$('td').removeClass('selected');
		return false;
	});

	var markSeat = function(seat, row, col) {
		data[row][col] = 'x';
		var taken = 'taken';
        var $seat = $(seat);
		var value = null;
        if ( $seat.hasClass('filled') ) {
			value = 'nottaken'; 
		} else {
			value = 'taken';
		}
 		
		$('#mark-seat-form input[name=row]').val(row);
		$('#mark-seat-form input[name=col]').val(col);
		$('#mark-seat-form').slideDown();
		$('td').removeClass('selected');
       	$seat.addClass('selected');
	};

	var rows = 17;
	var cols = 21;
	var i, j;
	var tr, td, data;


	for (i = 0; i < rows; i++) {
		tr = $('<tr></tr>');
		for (j = 0; j < cols; j++) {

			td = $('<td></td>').click( (function (x, y) { return function () { markSeat(this, x,y);  }; }(i, j)) );
			if (j === 10) {
				td.addClass('isle');
			} else {
                td.addClass('seat');
            }

			tr.append(td);
		}

		$('#openseats').append(tr);
	}



	var displayData = function (data) {
		console.log('receiving update');
		var i, j;
		var td;
		for (i = 0; i < rows; i++) {
			tr = $('<tr></tr>');
			for (j = 0; j < cols; j++) {
				td = $('table tr').eq(i).find('td').eq(j);
				if (data[i][j] != null) {
					td.addClass('filled');
					if (td.find('img').length === 0) {
                        console.log(data[i][j]);
						td.append('<img>');
					}
					if (data[i][j] !== 'x' && data[i][j] !== 'taken') {
						td.find('img').attr('src', 'https://api.twitter.com/1/users/profile_image/' + data[i][j]);	
					}
				} else {
					td.removeClass('filled').find('img').remove();
				}
			}

		}
	};

	var updateFromServer = function () {
		console.log('asking server for update');
		
		$.getJSON('/seats.json', function (d) { data = d; displayData(d); });
	};
	
	
	updateFromServer();
	//setInterval( updateFromServer, 10000);





});

