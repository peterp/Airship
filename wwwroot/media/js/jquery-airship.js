
// FileManager, performs all the basic file management things that a person should expect.

;(function($) {
    
    var relativePath = '';
    
    $.fn.fileManager = function(atPath) {
        relativePath = atPath;
        this.ls = ls;
        this.rm = rm;
        this.mv = mv;
        this.mkdir = mkdir;
        return this;
    };
    
    function ls(callback)
    {
        $.post('/__/directory/list/', {'relativePath': relativePath}, function(r) {
            callback(r);
        }, 'json');
    };
    
    function mkdir(name, callback)
    {
        $.post('/__/directory/create/', {'name': name, 'path': relativePath}, function(r) {
            callback(r);
        });
    };
    
    function rm(files, callback)
    {
        $.post('/__/item/delete/', {'files[]': files, 'path': relativePath}, function(r) {
            callback(r);
        });
    };
    
    
    function mv(oldName, newName)
    {
    };
    // delete
    // rename
    // move (should be the same as rename)
    
}(jQuery));



// User interface stuff.......

;(function($) {
    
    var currentRelativePath;
    var fileManager;
    
    $.fn.airshipUI = function() {
        
        //create folder
        $('a[href=#new-folder]').mouseup(function() {
            
            // deselect selected rows.
            $('.selected').removeClass('selected');
            
            // find a suitable folder name
            var name = '';
            $('.scroll .name').each(function(i) {
                basename = i == 0 ? 'untitled folder' : 'untitled folder ' + i;
                if ($('.scroll .name a[href="#' + currentRelativePath + '/' + basename + '"]').length <= 0) {
                    name = basename;
                    return false;
                }
            });
            
            var d = new Date();
            var ul = createItemRow('Directory', name, 'Today, ' + d.getHours() + ':' + d.getMinutes(), '--', 'pseudo')
                .addClass('selected');
                
            // have to check which height is the higher...
			var list = $('.scroll div');
			list.append(ul);
			
			
			var h = $('.scroll div a').length * 38;
            if (h > parseInt(list.css('height'), 10)) {
                list.css('height', h);
            } else {
                list.css('height', $('.scroll').css('height'));
            }
			
	        
            
            // edit this row.
            renameItem(ul);
            
            return false;
        }).click(function() {
            return false;
        });
        
        // delete
        $('a[href=#delete]').mouseup(function() {
            
            var rmFiles = new Array();
            // grab selected rows
            $('.selected .name').each(function(i) {
                rmFiles.push(currentRelativePath + '/' + $(this).text());
            });
            
            if (rmFiles.length <= 0) {
                return;
            }
            
            // we should actually ask if you're sure if you want to delete these files.

            // delete these rows.
            fileManager.rm(rmFiles, function(r) {
                
                if (r == '1') {
                    $('.selected').remove();
                } else {
                    // error message.
                }
            });
        }).click(function() {
            return false;
        });

		
		// upload
		$('a[href=#upload]').mouseup(function() {
			
			var w = window.open('/upload.html', 'upload-' + currentRelativePath, 'height=600,width=505,location=false,resizable=false');
			if (window.focus) {
				w.focus();
			}
			
			w.uploadRelativePath = currentRelativePath;
			
			
			
		}).click(function() {
			return false;
		});
		
        
        
        $(window).resize(resizeFinderToFitWindow);
        resizeFinderToFitWindow();


        // only method we make public, 
        this.loadDirectoryItems = loadDirectoryItems;
        return this;
    };
    
    function resizeFinderToFitWindow(e)
    {
        var h = $(window).height() - 270;
        
        $('.scroll').css('height', h);
        $('.scroll div').css('height', h);
    };
    
    
    
    
    function loadDirectoryItems(atPath)
    {
        currentRelativePath = atPath;
        fileManager = $().fileManager(atPath);

        var list = $('.scroll div');
        list.html('');
        
        fileManager.ls(function(r) {
            
            if (r.length == 0) {
                // empty
                return;
            }
            
            var h = r.length * 38;
            if (h > parseInt(list.css('height'), 10)) {
                list.css('height', h);
            } else {
                list.css('height', $('.scroll').css('height'));
            }
            
            $(r).each(function(i) {
                list.append(createItemRow(this.kind, this.name, this.date, this.size));
            });
        });
        
        // update the path bar...
        updatePathTree();
    };
    
    
    function updatePathTree()
    {
        var pt = $('#path-tree');
        pt.html('');
        
        var dirPath = ''
        var dirTree = currentRelativePath.split('/');

        // need to rewrite this.
        for (i = 1; i < dirTree.length; i++) {

            dirPath += '/' + dirTree[i];
            $('<a href="#' + dirPath + '">' + dirTree[i] + '</a>').appendTo(pt);
            if (i < dirTree.length - 1) {
                $('<span>&gt;</span>').appendTo(pt);
            }
        }
    };
    
    
    
    
    function createItemRow(kind, name, date, size, mode)
    {
		var a = $('<a />')
			.addClass(mode)
			.attr('href', kind == 'Directory' ? '#' + currentRelativePath + '/' + name : currentRelativePath + '/' + name);
		
		$('<span class="mark" />').appendTo(a);
		$('<span class="icon" />').appendTo(a).addClass(kind);
		$('<span class="name" />').appendTo(a).html(name);
		$('<span class="date" />').appendTo(a).html(date);
		$('<span class="size" />').appendTo(a).html(size);
		
		a.mousedown(function() {
//			$(this).addClass('selected');
		})
		.mouseup(function() {
			
//			$(this).removeClass('selected');
		})
		.find('.mark').click(function(e) {

			var row = $(this).parent();
			if (row.hasClass('selected')) {
				row.removeClass('selected');
			} else {
				row.addClass('selected');
			}
			
			return false;
		});
        
        return a;
    };
    
    
    
    
    
    
    
    
    
    
    
    
    
    function renameItem(ul)
    {
        var pseudoMode = ul.hasClass('pseudo');
        var cachedName = ul.find('.name').text();


        
        var input = $('<input type="text" value="' + cachedName + '">')
            .keydown(function(e) {
                if (e.keyCode == 27) {

                    
                    if (pseudoMode) {
                        // Remove, cancel if creating.
                        $(this).parent().parent().remove();
                    } else {
                        // Restore to default if renaming
                        revertFromRenameToDefault($(this).parent(), cachedName);
                    }
                } else if (e.keyCode == 13) {
                    // Blur is save...
                    $(this).blur();
                }
            })
            .blur(function() {
                
                if (pseudoMode) {
                    
                    var val = $(this).val();
                    
                    fileManager.mkdir(val, function(r) {
                        
                        if (r.length <= 0) {
                            // Response is empty?
                            return;
                        }
                        
                        var c = parseInt(r, 10);
                        if (c > 0) {
                            revertFromRenameToDefault(ul.find('.name'), val);
                        } else {
                            // error
                            
                            switch(c) {
                                case -1:
                                    //You have to give your folder a name.
                                    break;
                                case -2:
                                    //You cannot use a name that begins with a \".,\" because those names are reserved for the system.
                                    break;
                                case -10:
                                    //\"%@\" could not be created, because its parent folder doesn't exist.
                                    break;
                                case -11:
                                    //The name \"%@\" is already taken. Please choose a different name.
                                    break;
                            }
                        }
                    });
            



                    
                } else { // Rename directory.
                    // move...
                }
            });

        ul.find('.name').html('').append(input);
        input.select().focus();
    };
    
    
    
    
    function revertFromRenameToDefault(nameColumn, name)
    {
        nameColumn.html($('<a href="#' + currentRelativePath + '/' + name + '">' + name + '</a>'));
    };
    
}(jQuery));