
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
        $.getJSON('/' + relativePath + '?format=json', function(r) {
            // run the callback function...
            callback(r);
        });
    };
    
    function mkdir(name, callback)
    {
        var params = { 'directoryName': name, 'relativePath': relativePath };
        $.post('/__/directory/create/', params, function(r) {
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
            
            if ($('#item-list').find('input').length > 0) {
                return;
            }
            
            var d = new Date();
            var ul = createItemRow('directory', 'untitled folder', 'Today, ' + d.getHours() + ':' + d.getMinutes(), '--', 'pseudo');
            $('#item-list').append(ul);
            renameItem(ul);
            
            return false;
        });
        
        
        // load up the "Storage" directory.
        loadDirectoryItems('Storage/');
    };
    
    function loadDirectoryItems(atPath)
    {
        currentRelativePath = atPath;
        fileManager = $().fileManager(atPath);

        var list = $('#item-list');
        list.html('');
        
        fileManager.ls(function(r) {
            $(r).each(function(i) {
                
                list.append(createItemRow(this.type, this.name, this.date, this.size));
            });
            
            // attach events...
            list.find('ul').mousedown(function(e) {
                
                
                list.find('.selected').removeClass('selected');
                
                $(this).addClass('selected');
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
                    renameItem(row);
                }
            });
        });
        
        // update the path bar... at the top or at the bottom?
        updatePathBreadcrumbs();
    };
    
    
    function updatePathBreadcrumbs()
    {
        var bc = $('#path-breadcrumbs');
        bc.html('');

        var path = ''
        var paths = currentRelativePath.split('/');
        paths.pop();
        $(paths).each(function(i) {
            path += this + '/';
            var a = $('<a href="#' + path + '">' + this + '</a>').click(function() {
                
                // this might be different in different browsers?
                loadDirectoryItems($(this).attr('href').substr(1));
            });
            bc.append(a);
            if (i < paths.length - 1) {
                $('<span>&gt;<span>').appendTo(bc);
            }
        });
    };
    
    // given the parameters it returns the appropriate row 
    function createItemRow(type, name, date, size, mode)
    {
        var ul = $('<ul/>').addClass(mode);
        $('<li class="type"></li>').appendTo(ul).addClass(type);
        $('<li class="name"></li>').appendTo(ul).html('<a href="#' + currentRelativePath + name + '/">' + name + '</a>');
        $('<li class="date"></li>').appendTo(ul).html(date);
        $('<li class="size"></li>').appendTo(ul).html(size);
        return ul;
    };
    
    
    function openItemRow(row)
    {
        var row = $(row);
        var type = row.find('.type')[0].className.split(' ')[1];
        var name = row.find('.name').text();

        if (type == 'directory') {
            loadDirectoryItems(currentRelativePath + name + '/');
        } else {
            
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
                fileManager = $().fileManager(currentRelativePath);

                if (pseudoMode) {
                    fileManager.mkdir($(this).val(), function(r) {
                        var r = r.split(';');
                        if (r.length == 0) {
                            // error;
                            return;
                        }
                      
                        if (parseInt(r, 10) > 0) {
                            // it worked, go back to normal mode, so the user can click.
                            revertFromRenameToDefault(ul.find('.name'), r[1]);
                        } else {
                            // error!
                            alert(r[1]);
                        }
                        // what do we do with the response?
                        console.log(r);
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
        console.log(nameColumn)
        
        nameColumn.html($('<a href="#' + currentRelativePath + name + '/">' + name + '</a>'));
    };
    
}(jQuery));