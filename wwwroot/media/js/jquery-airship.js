(function($) {
    

    var relativePath = 'Storage';

    $.fn.airship = function() {
        
        
        // actions
        $('#action-file-upload').fancybox({
            'hideOnContentClick': false,
			'padding': 18,
			'callbackOnStart': function() {

			    var href = 'upload.html?relativePath=' + relativePath;
			    $('#action-upload').attr('href', href);
			}
        });
        
        // create folder
        $('#action-directory-create').click(function() {
            // Insert A new Row called untitled folder.
            
            var d = new Date()
            var ul = $('<ul></ul>')
                .append('<li class="type ' + " " + '"></li>')
                .append('<li class="name"><input type="text" name="directoryName" id="directoryName"></li>')
                .append('<li class="date">Today, ' + d.getHours() + ':' + d.getMinutes() + '</li>')
                .append('<li class="size">' + '--' + '</li>')
            ul.prependTo('#item-list');
            
            
            ul.find('input')
                .blur(function() {
                    // save
                    $.post('/__/directory/create/', 
                        {'directoryName': this.value, 'relativePath': relativePath}, 
                        function(r) {
                            console.log(r);
                        });
                    
                    // remove element, actually, conver it to normal textnode.
                    
                })
                .keydown(function(e) {
                    if (e.keyCode == 27) {
                        // cancel
                        $(this).parent().parent().remove();
                    } else if (e.keyCode == 13) {
                        // save
                        $(this).blur();
                    }
                })
                .focus();
        }).click();
        
        
        directoryContentsAtPath(relativePath);
    };
    
    var directoryContentsAtPath = function(atPath)
    {
        $.getJSON('/' + atPath + '?format=json', function(r) {
            var list = $('#item-list');
            if (r.length == 0) {
            } else {
                $(r).each(function() {
                    var ul = $('<ul></ul>')
                        .append('<li class="type ' + " " + '"></li>')
                        .append('<li class="name">' + this.name + '</li>')
                        .append('<li class="date">' + this.date + '</li>')
                        .append('<li class="size">' + '--' + '</li>')
                    ul.appendTo(list);
                });
            }
        });
    };

})(jQuery);