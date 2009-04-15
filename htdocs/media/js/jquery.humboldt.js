;(function(jQuery) {
    
    var fm = null;
    
    $.fn.humboldt = function() 
    {
        resize();
        $(window).resize(resize);
        
        // attach event to upload files
        $('a[href=#upload_files]').click(function() {
            $('#dialog_upload').simpledialog();
            return false;
        });
        
        
        // load the files...
        fm = new fileManager();
        fm.get_by_filter('*');
    }
    
    function resize() 
    {
        var h = $(window).height() - 153;
        $('#frame, #sidebar, #sidebar .scroll, #main').height(h);
        $('#main .scroll').height(h - 36);
    };
    
    
    function fileManager()
    {
        var list;
        
        this.get_by_filter = function(filter) {
	
			// load up all the file using ajax
	
            list = $('#file_list ul');
            list.each(function(i) {
                var t = $(this);
                t.addClass(i % 2 ? 'odd' : '');
                var li = t.find('li');
                li.slice(0,1).click(function() {
                    $(this).find('input').click();
                    return false;
                }).find('input').click(function(e) {
                    // highlight row, or not.
                    e.stopPropagation();
                });
                
            });
        }
    };
})(jQuery);
