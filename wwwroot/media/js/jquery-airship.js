(function($) {
    

    var relativePath = 'Storage';

    $.fn.airship = function() {
        
        
        // upload
        $('#action-file-upload').fancybox({
            'hideOnContentClick': false,
			'padding': 18,
			'callbackOnStart': function() {
			    var href = 'upload.html?relativePath=' + relativePath;
			    $('#action-file-upload').attr('href', href);
			}
        });
        
        // create folder
        $('#action-directory-create').click(function() {
            // Insert A new Row called untitled folder.
            
            var d = new Date()
            var ul = $('<ul></ul>')
                .append('<li class="type ' + " " + '"></li>')
                .append('<li class="name"><input type="text" name="directoryName" id="directoryName" value="untitled folder"></li>')
                .append('<li class="date">Today, ' + d.getHours() + ':' + d.getMinutes() + '</li>')
                .append('<li class="size">' + '--' + '</li>')
            ul.prependTo('#item-list');
            
            renameItem(ul);
        });
        directoryContentsAtPath(relativePath);
    };
    
    var directoryContentsAtPath = function(atPath)
    {
        relativePath = atPath;
        
        $.getJSON('/' + atPath + '?format=json', function(r) {
            var list = $('#item-list');
            list.html('');
            if (r.length == 0) {
                // this folder is empty.
            } else {
                $(r).each(function() {
                    var ul = $('<ul></ul>')
                        .append('<li class="type ' + this.type + '"></li>')
                        .append('<li class="name">' + this.name + '</li>')
                        .append('<li class="date">' + this.date + '</li>')
                        .append('<li class="size">' + '--' + '</li>')
                    ul.appendTo(list)
                    
                });
                list.find('.name').click(openItem);
            }
        });
    };
    
    var openItem = function()
    {
        // figure out what type this is?
        var r = $(this).parent();
        var type = r.find('.type')[0].className.split(' ')[1];
        var name = r.find('.name').text()
        
        if (type == 'directory') {
            // change the directory path...
            // reload the thingum....
            directoryContentsAtPath(relativePath + '/' + name);
        }
    };
    
    var renameItem = function(row)
    {
        // find the input element in this row
        var input = row.find('input[type=text]');
        if (input.length) {
            // creating a new file.
            var action = 'create';
        } else {
            // editing an existing file.
            var action = 'rename';
        }
        
        input.blur(function() {
            // save on blur.
            
            $.post('/__/directory/' + action + '/', {'directoryName': input.val(), 'relativePath': relativePath}, function(r) {
                
                var r = r.split(';');
                if (r.length == 0) {
                    // error;
                    return;
                }
                
                if (parseInt(r, 10) > 0) {
                    // success, revert back to textmode.
                    input.parent().html(input.val());
                } else {
                    // error!
                    alert(r[1]);
                }
            });
        }).keydown(function(e) {
            if (e.keyCode == 27) {
                $(this).parent().parent().remove();
            } else if (e.keyCode == 13) {
                $(this).blur();
            }
        }).select().focus();
    };
    

})(jQuery);