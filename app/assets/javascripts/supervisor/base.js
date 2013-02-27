var app = ( function() {

    function init() {
      menu.init();
      utils.init_progress();
      utils.init_server_error_dialog();
      theme.init();
      utils.bind_hover($('#logout'));
      $('#menu_staff').addClass('menu_active');
      staff.load();
    }

    return {
      init : init
    };
}());

$(app.init);