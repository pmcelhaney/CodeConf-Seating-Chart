$(function () {

	var markSeat = function(seat, row, col) {
		data[row][col] = 'x';
		console.log(data);
		console.log('you clicked ' + row + ',' + col);
        var taken = 'taken';
        var $seat = $(seat);
        if( $seat.hasClass('filled') ){
            taken = 'nottaken';
        } else {
            taken = 'taken';
        }
        $.get('/update/row/'+row+'/col/'+col+'/mark/'+taken+'/');
		updateFromServer();
		
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
		var i, j;

		for (i = 0; i < rows; i++) {
			tr = $('<tr></tr>');
			for (j = 0; j < cols; j++) {
                if( i == 0 && j == 9 ){
                    console.log("i: " + i + " j: " + 9 + " -- " + data[i][j]);
                }
				if (data[i][j] == "x") {
					$('table tr').eq(i).find('td').eq(j).addClass('filled');
				} else {
					$('table tr').eq(i).find('td').eq(j).removeClass('filled');
				}
			}

		}
	};
	console.log(JSON.stringify(data));

	var updateFromServer = function () {
		$.getJSON('/seats.json', function (d) { data = d; displayData(d); });
	};
	
	
	updateFromServer();
	setInterval( updateFromServer, 10000);





});

