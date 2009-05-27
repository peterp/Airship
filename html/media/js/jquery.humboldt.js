;(function($) {
    

    var path = '/storage';
    var aggragate_size;

    $.fn.humboldt = function()
    {
        item_list = $('#item_list');
        // reset all selected items.
        item_list.find('.scroll').mousedown(function() {
            console.log('.scroll')
            $(this).find('ul.selected').removeClass('selected');
            return false;
        });
        
        
        resize_window();
        $(window).resize(resize_window);
  
        // load the files from the path...
        get_items(path);
  
    };
    
    
    var get_items = function(at_path)
    {
        // modify system-wide path
        path = at_path;
        console.log(path);
        
        var item_list = $('#item_list .scroll');
        item_list.html('');
        
        $.get('__' + at_path, {}, function(r) {
            if (r.length) {
                $(r).each(function() {
                    item_list.append(build_item_row(this.type, this.name, this.date, this.size));
                });
            };
        }, 'json');
        
        // update path bar...
        var path_bar = $('#path_bar');
        path_bar.html('');
        var path_list = path.split('/');
        var open_path = '';
        $.each(path_list, function() {
            var f = this.toString();
            
            if (f.length > 0) {
                open_path += '/' + f;
                path_bar.append($('<li/>').text(f).attr('rel', open_path).click(function() {
                    get_items($(this).attr('rel'));
                }));
            }
        });
    };
    
    var build_item_row = function(type, name, date, size)
    {
        size = type == 'folder' ? '--' : humanize_size(size);
        
        var ul = $('<ul/>').addClass(type)
            .append($('<li/>').addClass('cbox'))
            .append($('<li/>').addClass('icon'))
            .append($('<li/>').addClass('name').text(name))
            .append($('<li/>').addClass('date').text(date))
            .append($('<li/>').addClass('size').text(size))
            .append($('<li/>').addClass('type').text(type));
            
        // rename
        ul.find('li.name').mousedown(function(e) {
            
            var ul = $(this).parents('ul');
            // is it already selected.

            if (ul.hasClass('selected') && !$('#item_list ul.selected').length <= 0) {
                setTimeout(function() {
                    console.log('rename');
                    rename_item_row(ul);
                }, 200);
                return false;
            }
        });
        
        // select
        ul.mousedown(function(e) {
            console.log('ul');
            var ul = $(this);
            if (!e.metaKey) {
                $('#item_list ul').removeClass('selected');
                ul.addClass('selected');
            } else {
                ul.toggleClass('selected');
            }
            return false;
        });
        
        
        // open
        ul.dblclick(function(e) {
            
            var ul = $(this);
            
            var item_name = ul.find('.name').text();
            if (ul.hasClass('folder')) {
                get_items(path + '/' + item_name);
            } else {
                // file... open preview/ download?
            }
            return false;
        });
        
        
        // ul.draggable({
        //           scroll: true,
        //           cursor: 'move',
        //           cursorAt: {top: -12, left: -20 },
        //           helper: function(e) {
        //               return $('<div class="ui-widget-header">Woah!</div>')  
        //           },
        //           revert: true,
        //       });
        
        
        
            
        return ul;
    };
    
    
    var rename_item_row = function(ul)
    {
        ul.find('.name').css('color', 'red');
    };
    
    
    


    var resize_window = function()
    {
      var h = $(window).height() - 182;
      $('#sidebar').height(h)
        .find('.scroll').height(h);
      $('#item_list').height(h)
        .find('.scroll').height(h - 72);
    };

    var humanize_size = function(bytes)
    {
      var u = [' B', ' KB', ' MB', ' GB'];
      for (var i = 0; bytes > 1024; i++) {
          bytes /= 1024;
      }
      return Math.round(bytes*100)/100 + u[i]
    };
})(jQuery);