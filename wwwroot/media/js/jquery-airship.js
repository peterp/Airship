
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
    
    function rm()
    {
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
                if ($('.scroll .name a[href="#/' + currentRelativePath + '/' + basename + '"]').length <= 0) {
                    name = basename;
                    return false;
                }
            });
            
            var d = new Date();
            var ul = createItemRow('Directory', name, 'Today, ' + d.getHours() + ':' + d.getMinutes(), '--', 'pseudo')
                .addClass('selected');
            $('.scroll div')
                .css('height', $('.scroll ul').length * 38)
                .append(ul);
            
            // edit this row.
            renameItem(ul);
            
            return false;
        }).click(function() {
            return false;
        });


        
        // load up the "Storage" directory.
        loadDirectoryItems('Files');
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
            
            list.css('height', r.length * 38);
            
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
        
        
        for (i = 0; i < dirTree.length; i++) {
            
            if (i > 0) {
                 dirPath += '/';
            }
            dirPath += dirTree[i];
            
            var a = $('<a href="#' + dirPath + '">' + dirTree[i] + '</a>').click(function() {
                // might be different in diff browsers.
                loadDirectoryItems($(this).attr('href').substr(1));
            }).appendTo(pt);
            
            if (i < dirTree.length - 1) {
                console.lo
                $('<span>&gt;</span>').appendTo(pt);
            }
            
        }
    };
    
    // given the parameters it returns the appropriate row 
    function createItemRow(kind, name, date, size, mode)
    {
        var ul = $('<ul/>').addClass(mode);
        $('<li class="icon"></li>').appendTo(ul).addClass(kind)
        $('<li class="name"></li>').appendTo(ul).html('<a href="#/' + currentRelativePath + '/' + name + '">' + name + '</a>');
        $('<li class="date"></li>').appendTo(ul).html(date);
        $('<li class="size"></li>').appendTo(ul).html(size);
        
        ul.mousedown(function(e) {
            
            // if row is deselected, return it back to normal
            if (!e.metaKey) {
                // deselect all
                $('.selected').removeClass('selected');
                $(this).addClass('selected');
            } else {
                
                if ($(this).hasClass('selected')) {
                    $(this).removeClass('selected');
                } else {
                    $(this).addClass('selected');
                }
            }
        })
        .mouseup(function(e) {
            
            if (e.metaKey) {
                return;
            }

            var row = $(this);
            if (e.detail == 1) {
                // set a timeout...
                timeoutID = setTimeout(function() {
                    openItemRow(row);
                }, 250);
                
                
            } else if (e.detail == 2) {
                // cancel the timer...
                clearTimeout(timeoutID);
                renameItem(row);
            }
        });
        return ul;
    };
    
    
    function openItemRow(row)
    {
        var kind = $(row).find('.icon')[0].className.split(' ')[1];
        var name = $(row).find('.name').text();

        if (kind == 'Directory') {
            loadDirectoryItems(currentRelativePath + '/' + name);
        } else {
            // view/ preview a file.
            
        }
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
                
                fileManager = $().fileManager(currentRelativePath);
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
        nameColumn.html($('<a href="#/' + currentRelativePath + '/' + name + '">' + name + '</a>'));
    };
    
}(jQuery));