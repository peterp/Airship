
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
        $.post('/__/directory/create/', {'directoryName': name, 'relativePath': relativePath}, function(r) {
            callback(r);
        });
    };
    
    function rm()
    {
    };
    
    
    function mv(oldName, newName)
    {
    };
    // list directory items.
    // delete
    // createDirectory
    // rename
    // move (should be the same as rename)
    
}(jQuery));



// User interface stuff.......

;(function($) {
    
    var currentRelativePath;
    var fileManager;
    
    $.fn.airshipUI = function() {
        
        // upload
        // $('#action-upload').click(function() {
        //  
        //  
        //  // Open a new popup window.
        //  $('#dialog-upload').modal({
        //      
        //  });
        //  
        //  
        //  
        //  
        //  return false;
        // });
        // $('#action-file-upload').fancybox({
        //     'hideOnContentClick': false,
        //     'padding': 18,
        //     'callbackOnStart': function() {
        //         var href = 'upload.html?currentRelativePath=' + encodeURIComponent(currentRelativePath);
        //         $('#action-file-upload').attr('href', href);
        //     }
        // });
        
        // create folder
        // $('#action-directory-create').click(function() {
        //     
        //     if ($('#item-list').find('input').length > 0) {
        //         return;
        //     }
        //     
        //     var d = new Date();
        //     var ul = createItemRow('directory', 'untitled folder', 'Today, ' + d.getHours() + ':' + d.getMinutes(), '--', 'pseudo');
        //     $('#item-list').append(ul);
        //     renameItem(ul);
        //     
        //     return false;
        // });
        
        
        // load up the "Storage" directory.
        loadDirectoryItems('Files');
        
        
        // Set the height of this window according to the browsers height.
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
            
            list.css('height', (r.length + 1) * 36);
            
            $(r).each(function(i) {
                list.append(createItemRow(this.kind, this.name, this.date, this.size));
            });
        });
        
        // update the path bar... at the top or at the bottom?
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
                $('<span>&gt;</span>').appendTo(bc);
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
                
            var row = $(this);
            if (e.detail == 1) {
                // set a timeout...
                timeoutID = setTimeout(function() {
                    openItemRow(row);
                }, 250);
            } else if (e.detail == 2) {
                // cancel the timer...
                clearTimeout(timeoutID);
                if (!e.metaKey) {
                    renameItem(row);
                }
            }
        });
        return ul;
    };
    
    
    function openItemRow(row)
    {
        var row = $(row);
        var kind = row.find('.icon')[0].className.split(' ')[1];
        var name = row.find('.name').text();

        if (kind == 'directory') {
            loadDirectoryItems(currentRelativePath + '/' + name);
        } else {
            // view/ preview a file.
            
        }
    };
    
    function renameItem(ul)
    {
        // we don't want the user to create more than 1 row...
        var pseudoMode = ul.hasClass('pseudo');
        var cachedName = ul.find('.name').text();
        
        var input = $('<input type="text" value="' + cachedName + '">')
            .keydown(function(e) {
                if (e.keyCode == 27) {
                    // check the mode...
                    if (pseudoMode) {
                        $(this).parent().parent().remove();
                    } else {

                        revertFromRenameToDefault($(this).parent(), cachedName);
                    }
                } else if (e.keyCode == 13) {
                    $(this).blur();
                }
            })
            .blur(function() {
                
                
                console.log('iasjdaiosjd')
                
                fileManager = $().fileManager(currentRelativePath);

                if (pseudoMode) {
                    fileManager.mkdir($(this).val(), function(r) {
                            
                        if (r.length <= 0) {
                            // error;
                            alert('no return value')
                            return;
                        }
                        
                        var c = parseInt(r[0], 10);
                        if (c <= 0) {
                            // something bad happended dude.
                            alert(r.split(';')[1]);
                        } else if (c == 1) {
                            revertFromRenameToDefault(ul.find('.name'), r.substr(2));
                        } else {
                            alert('not a valid return...');
                        }
                    });
                } else {
                    // move...
                }
            });

        ul.find('.name').html('').append(input);
        input.select().focus();
    };
    
    function revertFromRenameToDefault(nameColumn, name)
    {
        
        nameColumn.html($('<a href="#' + currentRelativePath + name + '/">' + name + '</a>'));
    };
    
}(jQuery));