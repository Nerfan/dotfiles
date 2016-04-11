/*******************************************************************
********************************************************************
Copyright 2012 Tim Perkins
********************************************************************
*******************************************************************/

$(document).ready(function() {
	// ********** Random ID code project *************
	// var rand = randString();
	// localStorage.timRand = rand;
	// alert(localStorage.timRand);
	var formName = "RegOfferings";
	if(window.location == "https://gamma.byu.edu/ry/ae/prod/registration/cgi/regEnvelopes.cgi") {
		formName = "RegEnvelopes";
	}
	$('form').each(function() {
		if($(this).attr('name') == formName) {
			$(this).before($('<div style="color: #222; font-size: 12px; background: #f0ffed; margin: 0 0 10px 0; padding: 10px; border: solid 1px #199500; border-radius: 8px; -moz-border-radius: 8px; -moz-box-shadow: 0 0 10px #bbb; -webkit-box-shadow: 0 0 10px #bbb; box-shadow: 0 0 10px #bbb;">Thank you for downloading Professor Plug! Please share the love by <a href="http://www.facebook.com/sharer/sharer.php?u=http%3A%2F%2Fwww.facebook.com%2Fprofessorplug" target="_blank" class="green" style="color: #199500;">sharing this on Facebook</a>!</div>'));
		}
	});
	// var timLines = new Array('is really cool', 'a.k.a. the jackhammer', 'Go Cougars!', 'likes to give high fives!', 'Penny is cute!', 'funky rainbow guacamole', 'disco puppies!', 'dinosaur salad?!', 'magic soft boots?');
	// var timLinesCount = timLines.length;
	// var curLineNum = 0;
	// $('#tim-dev').hover(function() {
	// 	// var randLine = Math.floor(Math.random()*timLinesCount);
	// 	var curLine = timLines[curLineNum];
	// 	$(this).html(curLine);
	// 	curLineNum = (curLineNum < (timLinesCount - 1)) ? (curLineNum + 1) : 0;
	// }, function() {
	// 	$(this).html('developer');
	// });
	
	
	var prfList = new Array(); 
	var classList = new Array(); 
	var prfCount = 0;
	var tableNum = 1;
	if(formName == "RegEnvelopes") {
		tableNum = 0;
	}
	var classTable = $('table.application:eq(' + tableNum + ')');
	var headerHighlight = {
		'background' : '#30831F' 
	};
	var highlight = {
		'display' : 'block',
		'background' : '#eee', 
		'color' : '#222',
		'padding' : '2px 5px'
	};
	var highlightCenter = {
		'background' : '#eee',
		'color' : '#000',
		'text-align' : 'center' 
	};
	var tdNum = 17;
	if(formName == "RegEnvelopes") {
		tdNum = 17;
	}
	var ratingHeader = $('<th>Prof<br />Rating</th>').css(headerHighlight);
	// var easinessHeader = $('<th>Easi-<br />ness</th>').css(headerHighlight);
	var professorHeaderDOM = classTable.find('th:eq(' + tdNum + ')').html('Professor Plug <br /><span style="font-weight: normal">(click for reviews)</span>').css(headerHighlight);
	// professorHeaderDOM.after(easinessHeader).after(ratingHeader);
	professorHeaderDOM.after(ratingHeader);
	
	// var easinessHeaderDOM = ratingHeaderDOM.after(ratingHeader);
	// var ratingHeaderDOM = professorHeaderDOM.before(easinessHeader);
	var rowCount = classTable.find('tr').length;
	classTable.find('tr').each(function(i) {
		var ratingCell = $('<td></td>');
		
		$(this).find('td:eq(' + tdNum + ')').after(ratingCell);		
		if($(this).find('td').length > 5 && $(this).find('td:eq(' + tdNum + ')').html().length > 9) { 
			var prfCell = $(this).find('td:eq(' + tdNum + ')');
			var fullName = prfCell.html(),
				cleanFullName = (fullName.indexOf('&nbsp;') > -1) ? fullName.replace('&nbsp;', '') : fullName,
				nameArr = (cleanFullName.indexOf(', ') > -1) ? cleanFullName.split(', ') : new Array(cleanFullName, ""),
				lastName = (nameArr[0].indexOf(' ') > -1) ? nameArr[0].replace(' ', '') : nameArr[0],
				firstName = nameArr[1];
			// Remove middle name
			/*
			if(firstName.indexOf(' ') > -1) {
				var firstNameArr = firstName.split(' ');
				firstName = firstNameArr[0].replace(' ', '');
			}
			*/
			prfCount = prfList.length;
			var row = {
				num: prfCount, 
				selector: $(this),
				prfCell: prfCell,
				ratingCell: ratingCell,
				fullName: fullName,
				cleanFullName: cleanFullName,
				firstName: firstName,
				lastName: lastName
			};
			classList.push(row); 
			var inArr = false;
			for(var j=0; j<prfCount; j++) {
				if(prfList[j].lastName == lastName && prfList[j].firstName == firstName) {
					inArr = true;
					row.num = j;
					break;
				} else {

				}
			}

			if(!inArr && (lastName.length > 0)) {
				prfList.push(row); 
			} else {

			}
		}
		if(i==(rowCount-1)) {
			var queryString = "";
			for(var k = 0; k < prfList.length; k++) {
				queryString += (k > 0) ? '&' : '?';
				queryString += 'prf' + k + '=' + prfList[k].lastName + ',' + prfList[k].firstName;
			}
			$.post("http://rating.tjpwebdesign.com/pages/search.php" + queryString, function(data) {
				var returnArr = jQuery.parseJSON(data);
				for(var t = 0; t < classList.length; t++) {
					var profNum = classList[t].num;
					if(returnArr[profNum]!=null) {
						classList[t].prfCell.html('&nbsp;<a class="fancy green" target="_blank" style="color: #199500;" href="http://www.ratemyprofessors.com/' + returnArr[profNum].link + '#profName">' + classList[t].cleanFullName + ' (' + returnArr[profNum].num_ratings + ')</a>');
						classList[t].ratingCell.html('<a class="fancy green" style="color: #199500;" target="_blank" href="http://www.ratemyprofessors.com/' + returnArr[profNum].link + '#profName">' + returnArr[profNum].rating + '</a>');				
					} else {
						classList[t].ratingCell.html('none');	 										
					}
				}
				// $('body').prepend(queryString);
				//setFancybox();
				setLinkHover();
			});	
		}
	});
});

function setFancybox() {
	$('.fancy').fancybox({
		'type' : 'iframe' 
	});
}
function setLinkHover() {
	$('.green').hover(function() {
		$(this).css({'color' : '#426E3B', 'border-bottom' : 'dotted 1px #999'});
	}, function() {
		$(this).css({'color' : '#199500', 'border-bottom' : 'none'});
	});
}
	
function randString() {
	var n = 10;
    var text = '';
    var possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    for(var i=0; i < n; i++)
    {
        text += possible.charAt(Math.floor(Math.random() * possible.length));
    }

    return text;
}
