(function($) {
    

    var relative_path = 'Storage';

    $.fn.airship = function(options) {
        
        
        // actions
        $('#action-upload').fancybox({
            'hideOnContentClick': false,
			'padding': 18,
			'callbackOnStart': function() {

			    var href = 'upload.html?relative_path=' + relative_path;
			    $('#action-upload').attr('href', href);
			}
        });
        
        // create folder
      
    };

})(jQuery);