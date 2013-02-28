var reservation = ( function() {
    var url = {
      add : '/admin/resv/new/',
      create : '/admin/resv/create/',
      edit : '/admin/resv/edit/',
      update : '/admin/resv/update/',
      del : '/admin/resv/delete/',
      list : '/admin/resv/list/',
      update_location : '/admin/resv/update/location/',
      update_status : '/admin/resv/update/status/',
      find_name : '/admin/resv/find/name/'
    };
    
    var popup_dialog_opt = null;

    function init_ui_opt() {
      popup_dialog_opt = {
        autoOpen : false,
        width : 380,
        resizable : false,
        draggable : true,
        modal : false,
        stack : true,
        zIndex : 1000
      };
    }
    
    function init_widget() {
      $.widget("ui.timespinner", $.ui.spinner, {
        options: {
          // seconds
          step: 60 * 1000,
          // hours
          page: 60
        },
         
        _parse: function(value) {
          if (typeof value === "string") {
            // already a timestamp
            if (Number(value) == value) {
              return Number(value);
            }
             
            return +Globalize.parseDate(value);
          }
          return value;
        },
         
        _format: function(value) {
          return Globalize.format(new Date(value), "t");
        }
      });
    }
    
    function show_form() {
      $('#dialog_add_body').load(url.add, function() {
        $('#id_reserve_time').timespinner();
        $('.save_form .date_input').datepicker(utils.date_opt());
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
        $('#id_reserve_time').timespinner();
        $('.save_form .date_input').datepicker(utils.date_opt());
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
      delete_helper(trlist, l);
    }
    
    function delete_helper(trlist, idlist) {
      var val = $('#id_pg').val();
      var arr = val.split(',');
      var currpg = parseInt(arr[3], 10);
      --currpg;
      var pgsize = $('#id_display').val();
      var data = get_search_param();
      data['id[]'] = idlist;
      data['pgnum'] = currpg;
      data['pgsize'] = pgsize;

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
    
    function func_update_status() {
      var e = $(this);
      var id = e.parent().parent().attr('id');
      var data = {
        status : e.val()
      };
      
      id = utils.get_itemid(id);
      $.post(url.update_status + id, data, function(result) {
        if (result.error == 1)
          e.val(result.status);
      });
    }

    function select_all() {
      var a = $(this).attr('checked');
      if (a == 'checked')
        $('.chk').attr('checked', 'checked');
      
      else
        $('.chk').removeAttr('checked');
    }

    function get_data(t) {
      var form = (t == 'add' ? $('#add-form') : $('#edit-form'));

      var data = {
        reserve_date : form.find('#id_reserve_date').val(),
        reserve_time : form.find('#id_reserve_time').val(),
        name : form.find('#id_name').val(),
        pax : form.find('#id_pax').val(),
        table : form.find('#id_table').val(),
        phone_no : form.find('#id_phone').val(),
        remarks : form.find('#id_remarks').val(),
        location : form.find('#id_location').val(),
        status : form.find('#id_status').val()
      };

      return data;
    }
    
    function get_search_param() {
      var param = {
        reserve_date : $('#id_query_date').val(),
        reserve_time : $('#id_query_time').val(),
        name : $('#id_query_name').val(),
        location : $('#id_query_location').val()
      };
      
      return param;
    }
    
    function sort_list() {
      var s = sort.set_sort_css($(this));
      nav_list.set_sort(s);
    }
    
    function delete_item(evt) {
      evt.stopPropagation();
      var id = $(this).parent().parent().attr('id');
      var trlist = ['#' + id];
      id = utils.get_itemid(id);
      var l = [id];
      delete_helper(trlist, l);
    }
    
    function init_list() {
      $('.hdchk').click(select_all);
      utils.bind_hoverlist($('.list_table tbody tr'));
      $('.list_table tbody').selectable({
        selected : function(evt, ui) {
          var id = ui.selected.id;
          func_edit(id);
        },
        cancel : '.deleteicon,input,textarea,button,select,option'
      });
      $('.sortheader').click(sort_list);
      $('.location').change(func_update_location);
      $('.status').change(func_update_status);
      $('.list_table tbody tr').hover(function() {
        $(this).find('.deleteicon').show();
      }, function() {
        $(this).find('.deleteicon').hide();
      });
      $('.list_table tbody tr .deleteicon').click(delete_item);
    }

    function init() {
      init_ui_opt();
      init_widget();
      $('#id_query_name').autocomplete({
        source : url.find_name,
        minLength : 2
      });
      $('#id_add').click(show_form);
      $('.date_input').datepicker(utils.date_opt());
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
      return menu.get('/admin/resv/', init);
    }
    
    return {
      load : load
    };
}());