$(function() {
	if(window.location.href.search("comments") == -1) {
		var lastPost = searchPosts(""); //last comment on each page. used as reference to load next page.
		var page = [];//for RES, keep track of what pages have been loaded already
		page.push("#page=1");
		
		$(window).on('hashchange', function() {
			if(page.indexOf(window.location.hash) == -1) { //when on a new page that hasn't been loaded before, make titles red
				//update loaded pages
				page.push(window.location.hash);
				
				//keep track of last comment so next page loads from correct spot
				lastPost = searchPosts(lastPost);
			}
		});
	} 
	else {
		addMarkup();
		trackComments(0);
		$("span.morecomments a").click(function() {//when "load more comments" is clicked
			$("#openRiotNav,.closeRiot,.downRiot,.upRiot").off();//unbind event handlers
			setTimeout(function(){
				trackComments( parseInt($(".counterRiot").text().substring(0,1)) );//wait for comments to load then track
			}, 3000);
		});
	}
});

/********************
***Start Functions***
********************/
function addMarkup() {
	//if there are no comments, stop
	if($("p>span.flair-riot").length == 0) { return; }
	
	//add markup for comment tracker
	$("body").append("<div class='riotNav'></div>");
	$(".riotNav").append("<div class='closeRiot'>X</div>");
	$(".riotNav").append("<div class='upRiot'></div>");
	$(".riotNav").append("<div class='counterRiot'>1/"+$("p>span.flair-riot").length+"</div>");
	$(".riotNav").append("<div class='downRiot'></div>");
	$(".riotNav").append("<p class='navAlert'>Comment Minimized</p>");
	
	//add button on nav toggle menu to make comment tracker appear if closed
	if($("#REScommentNavToggle").length) {
		$("#REScommentNavToggle").append("<span>|</span><div id='openRiotNav' class='flair flair-riot' title='Navigate through comments by Rioters'></div>");
	}
	else {
		$(".menuarea").append("<div id='openRiotNav' class='flair flair-riot' title='Navigate through comments by Rioters'></div>");
	}
}

function makePostRed(toBeRed) {
	//make link red
	toBeRed.style.setProperty('color', 'red', 'important');
	
	//mouseover turn pink, mouseoff turn red again
	$(toBeRed).hover(function() {
		this.style.setProperty('color', '#ff69b4', 'important');
	}, function() {
		this.style.setProperty('color', 'red', 'important');
	});
}

function searchPosts(afterPost) {
	var url; //to be used in the json request
	var postArray; //array of reddit post objects from json request
	var jqXHR; //jQuery XMLHttpRequest object
	var selfPost; //jQuery object of the reddit self post <a> tag to be made red
	var decodedURL; //external link url used to select <a> tag
	var externalPost; //jQuery object of the external link <a> tag to be made red
	
	//form json request url
	if (window.location.search.indexOf('after') == -1) {
		if (window.location.search == "") {
			url = window.location.protocol + '//' + window.location.hostname + window.location.pathname + '.json?after=' + afterPost;
		} else {
			url = window.location.protocol + '//' + window.location.hostname + window.location.pathname + '.json'+window.location.search+'&after=' + afterPost;
		}
	} else {
		url = window.location.protocol + '//' + window.location.hostname + window.location.pathname + '.json' + window.location.search;	//not RES
	}
	
	//json request. Synchronous because "jqXHR" is reference in the return statement
	jqXHR = $.ajax({
		dataType: "json",
		async: false,
		url: url
	});
	postArray = jqXHR.responseJSON.data.children;
	
	//loop through each reddit post retrieved 
	for(var i=0; i<postArray.length; i++ ) {
		//get json from all the posts' comment pages
		$.getJSON(window.location.protocol + "//www.reddit.com" + postArray[i].data.permalink + ".json")
			//when done, traverse comments looking for riot
			.done(function(commentTree) {
				if(traverse(commentTree[1].data.children)) { //if riot comment is found..
					//if comment was from a self post, get a reference to it and change CSS
					selfPost = $('a[href="'+commentTree[0].data.children[0].data.permalink+'"]');
					var test = commentTree[0].data.children[0].data.permalink;
					//if comment was from a external post, get a reference to it and change CSS
					decodedURL = $("<div/>").html(commentTree[0].data.children[0].data.url).text(); //decode html symbols in url, specifically "&"
					externalPost = $('a[href="'+decodedURL+'"]');
					
					if( selfPost.length > 0 ) {
						makePostRed(selfPost.get(1));
					}
					else if( externalPost.length > 0 ) {
						makePostRed(externalPost.get( externalPost.length-1 ));
					}
				}
			});
	}
	return jqXHR.responseJSON.data.after; //ID for the last comment
};

function trackComments(currentNum) {
	var allRiotComments = $("p>span.flair-riot"); //array of references to <p> tags that are riot comments
	var commentNum = currentNum; //current comment number, start at 0 because no comment is navigated to by default.

	//if there are no comments, stop
	if(allRiotComments.length == 0) { return; }
	
	//doing this operation up front makes it faster the first time the up/down arrow is clicked
	$(allRiotComments[0]).is(":visible");
	
	//make button open nav on click
	$("#openRiotNav").click(function() {
		$(".riotNav").css({"display" : "block"});
	});
	
	//close button functionality
	$(".closeRiot").click(function() {
		$(".riotNav").css({"display" : "none"});
	});
	
	//Up/down arrow functionality
	$(".downRiot").click(function() {
		//remove 'comment minimized' alert
		$(".navAlert").css({"display" : "none"});
		
		//un-highlight previous comment
		if(commentNum != 0) {
			$(allRiotComments[commentNum-1]).parent().parent().parent().get(0).style.setProperty('border-color', 'rgb(230, 230, 230)', 'important');
		}
		
		//update comment number -- if at last comment, go to 1st. Otherwise, go up 1.
		commentNum = (commentNum == allRiotComments.length) ? 1 : (commentNum + 1);
		
		if($(allRiotComments[commentNum-1]).is(":visible")) {
			//scroll to comment
			$('html,body').animate({scrollTop: $(allRiotComments[commentNum-1]).offset().top-($(window).height())/3},'slow');
			
			//highlight comment in red
			$(allRiotComments[commentNum-1]).parent().parent().parent().get(0).style.setProperty('border-color', 'red', 'important');
		}
		else { //if comment is minimized, it cannot be scrolled to. Alert user
			$(".navAlert").css({"display" : "block"});
		}
		
		//update counter
		$(".counterRiot").text(commentNum+"/"+allRiotComments.length);
	});
	
	$(".upRiot").click(function() {
		$(".navAlert").css({"display" : "none"});
		if(commentNum != 0) {
			$(allRiotComments[commentNum-1]).parent().parent().parent().get(0).style.setProperty('border-color', 'rgb(230, 230, 230)', 'important');
		}
		//if at first comment or not yet at a comment (commentNum=0), go to last. Otherwise, go down 1.
		commentNum = (commentNum < 2) ? allRiotComments.length : (commentNum - 1);
		
		if($(allRiotComments[commentNum-1]).is(":visible")) {
			$('html,body').animate({scrollTop: $(allRiotComments[commentNum-1]).offset().top-($(window).height())/3},'slow');
			$(allRiotComments[commentNum-1]).parent().parent().parent().get(0).style.setProperty('border-color', 'red', 'important');
		}
		else {
			$(".navAlert").css({"display" : "block"});
		}
		$(".counterRiot").text(commentNum+"/"+allRiotComments.length);
	});
	
	//Change styling on arrows when clicked
	$(".downRiot,.upRiot").mousedown(function() { $(this).toggleClass("changed"); });
	$(".downRiot,.upRiot").mouseup(function() { $(this).toggleClass("changed"); });
	
	//update counter - only applies when trackComments is called again after more comments are loaded
	$(".counterRiot").text(commentNum+"/"+allRiotComments.length);
}

function traverse(obj) {
	var flag=0;
	for(var i in obj) { 	//go through all comments in this level
		if(obj[i].data.author_flair_css_class == "riot") {
			//return 1 if any riot comments are found
			return 1;
		}
		else if( typeof(obj[i].data.replies) == "object") {
			//if there are replies to this comment, traverse them as well
			flag = traverse(obj[i].data.replies.data.children);
			if(flag){ return 1;}
		}
	}
	return flag;
};