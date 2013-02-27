var user = ( function() {
    var url = {
      edit : '/admin/user/edit/',
      update : '/admin/user/update/',
      list : '/admin/user/list/'
    };

    var popup_dialog_opt = null;

    function init_ui_opt() {
      popup_dialog_opt = {
        autoOpen : false,
        width : 350,
        resizable : false,
        draggable : true,
        modal : false,
        stack : true,
        zIndex : 1000
      };
    }

    function update_success() {
      func_cancel_edit();
      nav_list.show_list();
    }

    function func_cancel_edit() {
      $('#dialog-edit').dialog('close');
      return false;
    }

    function func_edit(id) {
      if (!id)
        return false;

      id = utils.get_itemid(id);
      $('#dialog_edit_body').load(url.edit + id, function() {
        $('#edit-form').find('#id_password').val('********');
        $('.save_button.save').click(function() {
          return func_update(id);
        });
        $('.save_button.cancel').click(func_cancel_edit);
        utils.bind_hover($('.save_button'));
        $('#dialog-edit').dialog('open');
      });
      return false;
    }

    function func_update(id) {
      var data = get_data('edit');
      $('#edit-form input').next().remove();
      $.post(url.update + id, data, function(result) {
        if (result.success == 1) {
          stat.show_status(0, result.message);
          update_success();
        }
        
        else if (result.error == 1) {
          for (var e in result.errors) {
            var d = $('#error_' + e).get(0);
            if (!d) {
              var o = {
                field : e,
                msg : result.errors[e][0]
              };
              var h = new EJS({
                url : '/assets/tpl/label_error.html',
                ext : '.html'
              }).render(o);
              $("#edit-form input[name='" + e + "']").after(h);
            }
          }
        }
        
        else
          utils.show_dialog(2, result);
      });

      return false;
    }

    function func_delete() {
      var a = $('.chk:checked');
      if (a.length < 1) {
        utils.show_dialog(2, 'Please select record(s).');
        return;
      }

      var l = [];
      var trlist = [];
      a.each(function(idx, elm) {
        var id = $(this).parent().parent().attr('id');
        trlist.push('#' + id);
        id = utils.get_itemid(id);
        l.push(id);
      });

      var val = $('#id_pg').val();
      var arr = val.split(',');
      var currpg = parseInt(arr[3], 10);
      --currpg;
      var pgsize = $('#id_display').val();
      var search_by = $('#id_selection').val();
      var keyword = $('#id_query').val();
      var data = get_search_param();
      data['id[]'] = l;
      data['pgnum'] = currpg;
      data['pgsize'] = pgsize;

      $.post(url.del, data, function(result) {
        if (result.success == 1) {
          stat.show_status(0, result.message);
          nav_list.set_item_msg(result.itemscount);
          var tr = $(trlist.join(','));
          tr.remove();
          delete tr;
          if ($('.list_table tbody tr')[0] == null) {
            $('.list_table').remove();
            utils.set_disabled('#id_delete', 1, null);
          }
        }
      });
    }

    function get_data(t) {
      var form = (t == 'add' ? $('#add-form') : $('#edit-form'));

      var data = {
        pwd : form.find('#id_password').val(),
        pwdconfirm : form.find('#id_passwordconfirm').val()
      };

      return data;
    }
    
    function sort_list() {
      var s = sort.set_sort_css($(this));
      nav_list.set_sort(s);
    }

    function init_list() {
      utils.bind_hoverlist($('.list_table tbody tr'));
      $('.list_table tbody').selectable({
        selected : function(evt, ui) {
          var id = ui.selected.id;
          func_edit(id);
        }
      });
      $('.sortheader').click(sort_list);
    }

    function init() {
      init_ui_opt();
      $('#id_display').change(nav_list.show_list);
      $('#dialog-edit').dialog(popup_dialog_opt);
      utils.init_alert_dialog('#dialog-message');
      nav_list.config.list_url = url.list;
      nav_list.config.list_func = init_list;
      nav_list.config.del_func = func_delete;
      nav_list.config.search_param_func = null;
      nav_list.init();
    }

    function load() {
      return menu.get('/admin/user/', init);
    }

    return {
      load : load
    };
}());