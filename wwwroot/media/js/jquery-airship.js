
;(function($) {
   
   	$.fn.airshipDialog = function(message, actions) {

	
		
		this.show = show;
		this.close = close;
		
		return this;
   	};

	function show(message, actions)
	{
        var o = $('<div />').css({
            opacity:0
        }).attr('id', 'dialogBG').appendTo('body').animate({opacity:.4}, 400);
       
       
        var d  = $('<div />')
            .append($('<div class="message">' + message + '</div><div class="actions"></div>'))
            .attr('id', 'dialog')
            .css('opacity', 0)
        .appendTo('body').animate({opacity:1}, 300);
       
       
        for (i = 0; i < actions.length; i++) {
            var action = actions[i];
            var a = $('<a/>').text(action.title).click(action.event);
            d.find('.actions').append(a);
        }
	};


	function close()
	{
		$('#dialogBG').animate({opacity:0}, 300, function() {
			$('#dialogBG').remove();
		});

		$('#dialog').animate({opacity:0}, 400, function() {
			$('#dialog').remove();
		});
	};

}(jQuery));


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
            
            for (i = 0; i <= $('.scroll .name').length; i++) {
                
                basename = i ? 'untitled folder ' + i : 'untitled folder';
                // try and find an element that matches basename, if it doesn't
                // match then this name is available.
                if ($('.scroll a[href=#' + currentRelativePath + '/' + basename + ']').length == 0) {
                    name = basename;
                    break;
                }
            };
            var d = new Date();
            var row = createItemRow('Directory', name, 'Today, ' + d.getHours() + ':' + d.getMinutes(), '--', 'pseudo')
                .addClass('selected');
            
            
            insertItemRowAlphabetically(row, name);
            
            // edit this row.
            renameItem(row);
            
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
            
           	$().airshipDialog().show('Are you sure you want to delete the selected items?', [
				{
					title: 'Cancel',
					event: function() {
						// close the dialog.
						$().airshipDialog().close();
					}
				},
				{
					title: 'Delete items',
					event: function() {
						
						$().airshipDialog().close();
					
						// Do the ajax call, the methods below should be in the ajax callback method
						// delete these rows.
			            fileManager.rm(rmFiles, function(r) {

			                if (r == '1') {
			                    $('.selected').remove();
			                } else {
			                    // error message.
			                }
			            });
					
					}
				}
			]);

            
        }).click(function() {
            return false;
        });

		
		// upload
		$('a[href=#upload]').mouseup(function() {
			
		    
			// suppose I need to test if the window exists?
            var w = window.open('/upload.html', 'upload' + currentRelativePath.replace(/[^\w0-9]+/g, '_'), 'height=600,width=505,location=false,resizable=false');
            w.uploadRelativePath = currentRelativePath;
			
            if (window.focus) {
                w.focus();
            }
               
            
			
		}).click(function() {
			return false;
		});
		
		
		
		
		// keyboard events
		
		$(document).keydown(function(e) {
		    
		    //console.log(e.keyCode)
		    
		    if (e.target.tagName != 'INPUT') {
		        
		        //console.log(e.keyCode);

		        switch (e.keyCode) {
		            
		            case 27:
		                $('.selected').removeClass('selected');
		                break;
		            
		            case 38:
		            case 40:
		                selectRowWithKeyBoard(e);
		                return false;
		                break;
		        }
		        
		    }
		});
		
        

        // only method we make public, 
        this.loadDirectoryItems = loadDirectoryItems;
        this.determineKindCreateAndInsertItemRow = determineKindCreateAndInsertItemRow;
        this.currentRelativePath = function() {
            return currentRelativePath;
        };
        
        return this;
    };
    
    
    
    function loadDirectoryItems(atPath)
    {
        currentRelativePath = atPath;
        fileManager = $().fileManager(atPath);

        var list = $('.scroll div');
        list.html('');
        
        fileManager.ls(function(r) {
            
            if (r.length == 0) {
                // empty, let the user know?
                return;
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
    
    function insertItemRowAlphabetically(row, name)
    {
        // inser the row based on the name...
        var itemRows = $('.scroll .name');

        if (itemRows.length <= 1) {
            $('.scroll div').append(row);
            return;
        }
        
        itemRows.each(function(i) {
            
            var n = $(this).text();
            
            // insert at correct position
            if (n.toLowerCase().localeCompare(name) >= 0) {
                
                // same position, do nothing
                if (n == name) {
                    // same row, do nothing
                    return false;
                } else {
                    // insert before.
                    $(this).parent().before(row)
                    return false;
                }
            }
            
            // insert as last row
            if (i == itemRows.length - 1) {
                $('.scroll div').append(row);
            }
        });
        
    };
    
    
    function determineKindCreateAndInsertItemRow(name, size)
    {
        
        var ext = name.split('.')
        ext = ext[ext.length - 1];
        var kind = 'Unknown';
        if (ext == 'jpg' || ext == 'jpeg' || ext == 'gif' || ext == 'tiff' || ext == 'png') {
            kind = 'Image';
        } else if (ext == 'aac' || ext == 'mp3' || ext == 'aiff' || ext == 'wav') {
            kind = 'Audio';
        } else if (ext == 'doc' || ext == 'docx' || ext == 'htm' || ext == 'html' || ext == 'key' || ext == 'numbers' || ext == 'pages' || ext == 'pdf' || ext == 'ppt' || ext == 'pptx' || ext == 'txt' || ext == 'rtf' || ext == 'xls' || ext == 'xlsx') {
            kind = 'Document';
        } else if (ext == 'm4v', ext == 'mp4', ext == 'mov') {
            kind = 'Video';
        }
        
        var d = new Date();
        var row = createItemRow(kind, name, 'Today, ' + d.getHours() + ':' + d.getMinutes(), size)
        
        insertItemRowAlphabetically(row, name);
    };
    
    
    
    
    
    
    function renameItem(row)
    {
        var pseudoMode = row.hasClass('pseudo');
        var cachedName = row.find('.name').text();

        // disable the link...
        row.click(function() { return false; });


        var input = $('<input type="text" value="' + cachedName + '">')
            .keydown(function(e) {
                if (e.keyCode == 27) {


                    if (pseudoMode) {
                        // Remove, cancel if creating.
                        $(this).parent().parent().remove();
                    } else {
                        // Restore to defarowt if renaming
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
                            revertFromRenameToDefault(row.find('.name'), val);


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
                                    //\"%@\" corowd not be created, because its parent folder doesn't exist.
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

        row.find('.name').html('').append(input);
        input.select().focus();
    };
    
    function revertFromRenameToDefault(nameColumn, name)
    {
        
        var row = nameColumn.parent();
        // enable the link.
        row.attr('href', row.find('.icon').hasClass('Directory') ? '#' + currentRelativePath + '/' + name : currentRelativePath + '/' + name);
        row.unbind('click');
        
        nameColumn.html(name);
        row.removeClass('pseudo');
        insertItemRowAlphabetically(row, name);
    };
    
    function selectRowWithKeyBoard(e) 
    {
        var goUp = e.keyCode == 38 ? true : false;
        var selected = $('.selected').length > 0 ? true : false;
        var multiple = e.shiftKey;
        
        //console.log(multiple);
        
        if (!selected) {
            if (goUp) {
                $('.scroll a:last').addClass('selected').focus();
            } else {
                $('.scroll a:first').addClass('selected').focus();
            }
        } else {
            
            var selectedRow = $('.selected:last');
            var nextSelectedRow;
            
            if (goUp) {
                nextSelectedRow = selectedRow.prev();
            } else {
                nextSelectedRow = selectedRow.next()
            }
            
            $('.selected').removeClass('selected');
            
            if (nextSelectedRow.length > 0) {
                nextSelectedRow.addClass('selected').focus();
            } else {
                selectedRow.addClass('selected').focus();
            }
        }
    }
    
}(jQuery));



