var kitchensch = ( function() {
    var url = {
      add : '/admin/sch/kitchen/new/',
      create : '/admin/sch/kitchen/create/',
      edit : '/admin/sch/kitchen/edit/',
      update : '/admin/sch/kitchen/update/',
      del : '/admin/sch/kitchen/delete/',
      list : '/admin/sch/kitchen/list/',
      update_location : '/admin/sch/kitchen/update/location/',
      week_days : '/admin/sch/week_days/',
      find_name : '/admin/sch/kitchen/find/name/',
      find_active_name : '/admin/sch/find/active/name/'
    };
    
    var popup_dialog_opt = null;

    function init_ui_opt() {
      popup_dialog_opt = {
        autoOpen : false,
        width : 650,
        resizable : false,
        draggable : true,
        modal : false,
        stack : true,
        zIndex : 1000
      };
    }
    
    function show_form() {
      $('#dialog_add_body').load(url.add, function() {
        $('#id_staff').autocomplete({
          source : url.find_active_name,
          minLength : 2,
          select : function(evt, ui) {
            $('#id_staff_id').val(ui.item.id);
          }
        }).data('ui-autocomplete')._renderItem = function(ul, item) {
           return $('<li>')
             .append('<a>' + item.label + ' (' + item.job + ')</a>')
             .appendTo(ul);
        };
        $('#add-form').find('#id_week').change(load_days);
        $('.save_button.save').click(func_save);
        $('.save_button.cancel').click(func_cancel_add);
        utils.bind_hover($('.save_button'));
        $('#dialog-add').dialog('open');
      });
    }

    function save_success() {
      func_cancel_add();
      nav_list.show_list();
    }

    function update_success() {
      func_cancel_edit();
      nav_list.show_list();
    }

    function func_cancel_add() {
      $('#dialog-add').dialog('close');
      return false;
    }
    
    function func_cancel_edit() {
      $('#dialog-edit').dialog('close');
      return false;
    }

    function func_save() {
      var data = get_data('add');
      $('#add-form input').next().remove();
      $.post(url.create, data, function(result) {
        if (result.success == 1) {
          stat.show_status(0, result.message);
          save_success();
        }
        
        else if (result.error == 1) {
          for (var e in result.errors) {
            var d = $('#error_' + e).get(0);
            if (!d) {
              var o = {
                field : e,
                msg : result.errors[e]
              };
              var h = new EJS({
                url : '/assets/tpl/label_error.html',
                ext : '.html'
              }).render(o);
              if (e == 'week')
                $('#add-form #id_' + e).after(h);
                
              else
                $("#add-form input[name='" + e + "']").after(h);
            }
          }
        }
        
        else
          utils.show_dialog(2, result);
      });

      return false;
    }

    function func_edit(id) {
      if (!id)
        return false;

      id = utils.get_itemid(id);
      $('#dialog_edit_body').load(url.edit + id, function() {
        $('#id_staff').autocomplete({
          source : url.find_active_name,
          minLength : 2,
          select : function(evt, ui) {
            $('#id_staff_id').val(ui.item.id);
          }
        }).data('ui-autocomplete')._renderItem = function(ul, item) {
           return $('<li>')
             .append('<a>' + item.label + ' (' + item.job + ')</a>')
             .appendTo(ul);
        };
        $('#edit-form').find('#id_week').change(load_days);
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
                msg : result.errors[e]
              };
              var h = new EJS({
                url : '/assets/tpl/label_error.html',
                ext : '.html'
              }).render(o);
              if (e == 'week')
                $('#edit-form #id_' + e).after(h);
                
              else
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
      var data = {
        'id[]' : l,
        pgnum : currpg,
        pgsize : pgsize,
        find : search_by,
        keyword : keyword
      };

      $.post(url.del, data, function(result) {
        if (result.success == 1) {
          stat.show_status(0, result.message);
          nav_list.set_item_msg(result.itemscount);
          var tr = $(trlist.join(','));
          tr.remove();
          delete tr;
          if ($('.list_table tbody tr').length < 1) {
            $('.list_table').remove();
            utils.set_disabled('#id_delete', 1, null);
          }
        }
      });
    }
    
    function func_update_location() {
      var e = $(this);
      var id = e.parent().parent().attr('id');
      var data = {
        location : e.val()
      };
      
      id = utils.get_itemid(id);
      $.post(url.update_location + id, data, function(result) {
        if (result.error == 1)
          e.val(result.location);
      });
    }

    function select_all() {
      var a = $(this).attr('checked');
      if (a == 'checked')
        $('.chk').attr('checked', 'checked');
      
      else
        $('.chk').removeAttr('checked');
    }
    
    function load_days() {
      var o = $(this);
      var data = {
        week : o.val()
      };
      $.post(url.week_days, data, function(result) {
        var n = result.length;
        for (var i = 0; i < n; i++) {
          $('.dis_date' + i).html(result[i]);
        }
      });
    }

    function get_data(t) {
      var form = (t == 'add' ? $('#add-form') : $('#edit-form'));
      var week = form.find('#id_week').val();

      var data = {
        category : form.find('#id_category').val(),
        staff_id : form.find('#id_staff_id').val(),
        location : form.find('#id_location').val(),
        week : week == '0' ? '' : week,
        mon : form.find('#id_mon').val(),
        tue : form.find('#id_tue').val(),
        wed : form.find('#id_wed').val(),
        thur : form.find('#id_thur').val(),
        fri : form.find('#id_fri').val(),
        sat : form.find('#id_sat').val(),
        sun : form.find('#id_sun').val()
      };

      return data;
    }
    
    function get_search_param() {
      var param = {
        category : $('#id_category').val(),
        name : $('#id_name').val(),
        location : $('#id_location').val(),
        week : $('#id_week').val()
      };
      
      return param;
    }
    
    function sort_list() {
      var s = sort.set_sort_css($(this));
      nav_list.set_sort(s);
    }
    
    function init_list() {
      $('.hdchk').click(select_all);
      utils.bind_hoverlist($('.list_table tbody tr'));
      $('.list_table tbody').selectable({
        selected : function(evt, ui) {
          var id = ui.selected.id;
          func_edit(id);
        }
      });
      $('.sortheader').click(sort_list);
      $('.location').change(func_update_location);
    }

    function init() {
      init_ui_opt();
      $('#id_name').autocomplete({
        source : url.find_name,
        minLength : 2
      });
      $('#id_add').click(show_form);
      $('#id_find').click(nav_list.show_list);
      $('#id_display').change(nav_list.show_list);
      $('#dialog-add').dialog(popup_dialog_opt);
      $('#dialog-edit').dialog(popup_dialog_opt);
      utils.init_alert_dialog('#dialog-message');
      utils.bind_hover($('#id_add,#id_delete,#id_find'));
      nav_list.config.list_url = url.list;
      nav_list.config.list_func = init_list;
      nav_list.config.del_func = func_delete;
      nav_list.config.search_param_func = get_search_param;
      nav_list.init();
    }
    
    function load() {
      return menu.get('/admin/sch/kitchen/', init);
    }
    
    return {
      load : load
    };
}());