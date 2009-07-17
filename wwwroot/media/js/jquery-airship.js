
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
    
    function mkdir(name)
    {
        var params = { 'directoryName': name, 'relativePath': relativePath };
        $.post('/__/directory/create/', params, function(r) {
            var r = r.split(';');
            if (r.length == 0) {
                // error;
                return;
            }

            if (parseInt(r, 10) > 0) {
                // success
            } else {
                // error!
                alert(r[1]);
            }
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
            // var d = new Date()
            // var ul = createItemRow('directory', 'untitled folder', 'Today, ' + d.getHours + ':' + d.getMinutes(), '--');
            // $('#item-list').append(ul);
            // renameItem(ul);
        });
        
        
        // load up the "Storage" directory.
        loadDirectoryItems('Storage');
    };
    
    var loadDirectoryItems = function(atPath)
    {
        currentRelativePath = atPath;
        fileManager = $().fileManager(atPath);

        var list = $('#item-list');
        list.html('');
        
        fileManager.ls(function(r) {
            $(r).each(function(i) {
                list.append(createItemRow(this.type, this.name, this.date, this.size));
            });
        });
    };
    
    
    // given the parameters it returns the appropriate row with 
    // the proper events attached.
    var createItemRow = function(type, name, date, size, mode)
    {
        var ul = $('<ul/>');
        $('<li class="type"></li>').appendTo(ul).addClass(type);
        $('<li class="name"></li>').appendTo(ul).html(name);
        $('<li class="date"></li>').appendTo(ul).html(date);
        $('<li class="size"></li>').appendTo(ul).html(size);
        
        return ul;
    };
    //   
    //   var createItemRow = function(type, name, date, size)
    //   {
    //       var ul = $('<ul></ul>')
    //           .append('<li class="type ' + type + '"></li>')
    //           .append('<li class="name">' + name + '</li>')
    //           .append('<li class="date">' + date + '</li>')
    //           .append('<li class="size">' + size + '</li>');
    //           
    //       ul.find('.name').click(openItem);
    //   };
    //   
    //   
    //   var openItem = function()
    //   {
    //       // figure out what type this is?
    //       var r = $(this).parent();
    //       var type = r.find('.type')[0].className.split(' ')[1];
    //       var name = r.find('.name').text();
    //       
    //       if (type == 'directory') {
    //           // change the directory path...
    //           // reload the thingum....
    //           directoryContentsAtPath(relativePath + '/' + name);
    //       }
    //       
    //       return false;
    //   };
    //   
    //   var renameItem = function(row)
    //   {
    //       // conver the items name into a input.
    //       row.find('.name').unbind('click').
    //       
    //       
    //       // find the input element in this row
    //       var input = row.find('input[type=text]');
    //       if (input.length) {
    //           // creating a new file.
    //           var action = 'create';
    //       } else {
    //           // editing an existing file.
    //           var action = 'rename';
    //       }
    //       
    //       input.blur(function() {
    //           // save on blur.
    //           
    //           $.post('/__/directory/' + action + '/', {'directoryName': input.val(), 'relativePath': relativePath}, function(r) {
    //               
    //               var r = r.split(';');
    //               if (r.length == 0) {
    //                   // error;
    //                   return;
    //               }
    //               
    //               if (parseInt(r, 10) > 0) {
    //                   // success, revert back to textmode.
    //                   console.log(input.parent());
    //                   input.parent().click(openItem);
    //                   input.parent().html(input.val());
    // 
    //               } else {
    //                   // error!
    //                   alert(r[1]);
    //               }
    //           });
    //       }).keydown(function(e) {
    //           if (e.keyCode == 27) {
    //               $(this).parent().parent().remove();
    //           } else if (e.keyCode == 13) {
    //               $(this).blur();
    //           }
    //       });
    //   };
}(jQuery));