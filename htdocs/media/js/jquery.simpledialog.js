(function(jQuery) {
	
	var modal = undefined;
	var $this = undefined;
	
    $.fn.simpledialog = function() 
    {
		$this = $(this);

		modal = $('<div/>').css({
			position:'absolute',
			top:0,
			left:0,
			width:'100%',
			height:'100%',
			background:'#000',
			opacity:.5,
			zIndex:10,
		}).appendTo('body');
		
		$this.css({
			position:'absolute',
			top:'50%',
			left:'50%',
			zIndex:20,
			background:'#fff',
			marginLeft:(($this.width() / 2) * -1),
			marginTop:(($this.height() / 2) * -1),
		}).toggle();
		
		// add a close button.
		$('<div/>').css({
			position:'absolute',
			height:18,
			width:18,
			background:'#fff',
			top:-4,
			right:-4,
			cursor:'pointer'
		}).click(function() {
			close();
		}).appendTo($this);
		
		$(document).one('keydown', function(e) {
			if (e.keyCode == 27) {
				close();
			}
		});
    };


	function close() {
		modal.remove();
		$this.toggle();
	};
    
    
})(jQuery);