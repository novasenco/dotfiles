-- Author: Nova Senco
-- Last Change: 11 September 2022

-- Init {{{1

-- Requires {{{2

pcall(require, "luarocks.loader")
local gears = require'gears'
local awful = require'awful'
require'awful.autofocus'
local wibox = require'wibox'
local beautiful = require'beautiful'
local naughty = require'naughty'
local ruled = require'ruled'
local menubar = require'menubar'
local hotkeys_popup = require'awful.hotkeys_popup'

local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")

-- Error Handling {{{2

naughty.connect_signal("request::display_error", function(message, startup)
  naughty.notification{
    urgency = "critical",
    title = "Oops, an error happened"..(startup and " during startup!" or "!"),
    message = message
  }
end)

-- Early Setup {{{2

beautiful.init(gears.filesystem.get_configuration_dir()..'nova/theme.lua')

-- Variable Definitions {{{2

local term = 'urxvtc'

local ed = os.getenv'EDITOR' or 'nvim'

local mod = 'Mod4'

-- Menu {{{3

local menu = {
  { 'hotkeys', function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { 'manual', term .. ' -e man awesome' },
  { 'edit config', string.format('%s -e %s %s', term, ed, awesome.conffile) },
  { 'restart', awesome.restart },
  { 'quit', function() awesome.quit() end },
}

local mainmenu = awful.menu({
  items = {
    { 'awesome', menu, beautiful.awesome_icon },
    { 'open terminal', term }
  }
})

local launcher = awful.widget.launcher({
  image = beautiful.awesome_icon,
  menu = mainmenu
})

-- Wallpaper {{{2

-- screen.connect_signal("request::wallpaper", function(s)
--   awful.wallpaper {
--     screen = s,
--     widget = {
--       {
--         image = os.getenv'HOME'..'/.backgrounds/dark/abstract_facets.jpg',
--         upscale = true,
--         downscale = true,
--         widget = wibox.widget.imagebox,
--       },
--       valign = "center",
--       halign = "center",
--       tiled = false,
--       widget = wibox.container.tile,
--     }
--   }
-- end)

-- Wibar {{{3

local kbdlayout = awful.widget.keyboardlayout()

local clock = wibox.widget.textclock()

-- }}}2

-- Setup {{{1

menubar.utils.terminal = term -- Set the terminal for applications that require it

-- Layouts {{{2

tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.tile,
        awful.layout.suit.floating,
        awful.layout.suit.max,
        -- awful.layout.suit.tile.left,
        -- awful.layout.suit.tile.bottom,
        -- awful.layout.suit.tile.top,
        -- awful.layout.suit.fair,
        -- awful.layout.suit.fair.horizontal,
        -- awful.layout.suit.spiral,
        -- awful.layout.suit.spiral.dwindle,
        -- awful.layout.suit.max.fullscreen,
        -- awful.layout.suit.magnifier,
        -- awful.layout.suit.corner.nw,
    })
end)


-- wibar {{{2

screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox{
        screen = s,
        buttons = {
            awful.button({}, 1, function() awful.layout.inc( 1) end),
            awful.button({}, 3, function() awful.layout.inc(-1) end),
            -- awful.button({}, 4, function() awful.layout.inc(-1) end),
            -- awful.button({}, 5, function() awful.layout.inc( 1) end),
        }
    }

    -- taglist widget {{{3

    s.mytaglist = awful.widget.taglist{
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({}, 1, function(t) t:view_only() end),
            awful.button({ mod }, 1,
              function(t)
                if client.focus then
                  client.focus:move_to_tag(t)
                end
              end),
            awful.button({}, 3, awful.tag.viewtoggle),
            awful.button({ mod }, 3,
              function(t)
                if client.focus then
                  client.focus:toggle_tag(t)
                end
              end),
            -- awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
            -- awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end),
        }
    }

    -- tasklist widget {{{3

    s.mytasklist = awful.widget.tasklist{
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button({}, 1, function(c)
                c:activate { context = 'tasklist', action = 'toggle_minimization' }
            end),
            awful.button({}, 3, function()
              awful.menu.client_list { theme = { width = 250 } }
            end),
            -- awful.button({}, 4, function() awful.client.focus.byidx(-1) end),
            -- awful.button({}, 5, function() awful.client.focus.byidx( 1) end),
        }
    }

    -- wibox {{{3

    s.mywibox = awful.wibar{
        position = "top",
        screen = s,
        widget = {
            layout = wibox.layout.align.horizontal,
            -- Left widgets
            {
                layout = wibox.layout.fixed.horizontal,
                launcher,
                s.mytaglist,
                s.mypromptbox,
            },
            -- Middle widget
            s.mytasklist,
            -- Right widgets
            {
              layout = wibox.layout.fixed.horizontal,
              wibox.widget.systray(),
              batteryarc_widget({
                show_current_level = true,
                arc_thickness = 3,
                show_notification_mode = 'on_click',
                font = 'Noto 9',
                charging_color = '#5f8787',
                bg_color = '#1c1c1c',
                size = 30,
                enable_battery_warning = false,
              }),
              kbdlayout,
              clock,
              s.mylayoutbox,
            },
        }
    }

    -- }}}3

end)

-- }}}2

-- Bindings {{{1

-- Mouse Bindings {{{2

awful.mouse.append_global_mousebindings({
    awful.button({}, 3, function() mainmenu:toggle() end),
    -- awful.button({}, 4, awful.tag.viewprev),
    -- awful.button({}, 5, awful.tag.viewnext),
})

-- Key Bindings {{{2

-- General Awesome Keys {{{3

awful.keyboard.append_global_keybindings({

  awful.key({ mod }, 's',
    hotkeys_popup.show_help,
    { description='show help', group='awesome' }
  ),

  awful.key({ mod }, 'w',
    function() mainmenu:show() end,
    { description='show main menu', group='awesome' }
  ),

  awful.key({ mod }, 'BackSpace',
    awesome.restart,
    { description='reload awesome', group='awesome' }
  ),

  awful.key({ 'Control', mod }, 'BackSpace',
    awesome.quit,
    { description='quit awesome', group='awesome' }
  ),

  awful.key({ mod }, 'x',
    function()
      awful.prompt.run{
        prompt = 'Run Lua code: ',
        textbox = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. '/history_eval'
      }
    end,
    { description='lua execute prompt', group='awesome' }
  ),

  awful.key({ mod }, 'Return',
    function() awful.spawn(term) end,
    { description='open a terminal', group='launcher' }
  ),

  awful.key({ 'Shift', mod }, 'Return',
    function() awful.spawn(term, {floating=true}) end,
    { description='open a terminal', group='launcher' }
  ),

  awful.key({ mod }, 'r',
    function() awful.screen.focused().mypromptbox:run() end,
    { description='run prompt', group='launcher' }
  ),

  awful.key({ mod }, 'p',
    function() awful.spawn('rofi -modi drun,run,ssh,window -show drun', false) end,
    { description='show rofi program picker', group='launcher' }
  ),

  awful.key({ 'Shift', mod }, 'p',
    function() menubar.show() end,
    { description='show the menubar', group='launcher' }
  ),

  awful.key({ 'Shift', mod }, 'b',
    function()
      local vis = not awful.screen.focused().mywibox.visible
      for s in screen do
        s.mywibox.visible = vis
      end
    end,
    { description='toggle the statusbar on all screens', group='awesome' }
  ),

  awful.key({ 'Control', mod }, 'b',
    function()
      local bar = awful.screen.focused().mywibox
      bar.visible = not bar.visible
    end,
    { description='toggle the statusbar on current screens', group='awesome' }
  ),

  awful.key({ mod }, 'g',
    function()
      local thm = beautiful.get()
      thm.gap_single_client = not thm.gap_single_client
      -- client.focus:emit_signal('manage')
      -- client.focus.maximized = not client.focus.maximized
      -- client.focus.maximized = not client.focus.maximized
      -- awesome.emit_signal('widget::layout_changed')
      -- f = io.open('foo.txt', 'w')
      -- f:write(require'inspect'(awful.screen.focused()))
      -- f:close()
    end,
    { description='toggle single client gap', group='awesome' }
  )

})

-- Tags Keybindings {{{3

awful.keyboard.append_global_keybindings{

  awful.key({ mod }, 'Left',
    awful.tag.viewprev,
    { description='view previous', group='tag' }
  ),

  awful.key({ mod }, 'Right',
    awful.tag.viewnext,
    { description='view next', group='tag' }
  ),

  awful.key({ mod }, 'Tab',
    awful.tag.history.restore,
    { description='go back', group='tag' }
  ),

}

awful.keyboard.append_global_keybindings({

  awful.key{
    modifiers = { mod },
    keygroup = 'numrow',
    description = 'only view tag',
    group = 'tag',
    on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        tag:view_only()
      end
    end,
  },

  awful.key{
    modifiers = { 'Control', mod },
    keygroup = 'numrow',
    description = 'toggle tag',
    group = 'tag',
    on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end,
  },

  awful.key{
    modifiers = { 'Shift', mod },
    keygroup = 'numrow',
    description = 'move focused client to tag',
    group = 'tag',
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end,
  },

  awful.key{
    modifiers = { 'Control', 'Shift', mod },
    keygroup = 'numrow',
    description = 'toggle focused client on tag',
    group = 'tag',
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end,
  },

  awful.key{
    modifiers = { mod },
    keygroup = 'numpad',
    description = 'select layout directly',
    group = 'layout',
    on_press = function(index)
      local t = awful.screen.focused().selected_tag
      if t then
        t.layout = t.layouts[index] or t.layout
      end
    end,
  }

})

-- Focus Keybindings {{{3

awful.keyboard.append_global_keybindings{

  awful.key({ mod }, 'j',
    function()
            awful.client.focus.byidx( 1)
        end,
    { description='focus next by index', group='client' }
  ),

  awful.key({ mod }, 'k',
    function()
            awful.client.focus.byidx(-1)
        end,
    { description='focus previous by index', group='client' }
  ),

  awful.key({ mod }, 'Tab',
    function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
    { description='go back', group='client' }
  ),

  awful.key({ 'Control', mod }, 'j',
    function() awful.screen.focus_relative( 1) end,
    { description='focus the next screen', group='screen' }
  ),

  awful.key({ 'Control', mod }, 'k',
    function() awful.screen.focus_relative(-1) end,
    { description='focus the previous screen', group='screen' }
  ),

  awful.key({ 'Control', mod }, 'n',
    function()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:activate { raise = true, context = "key.unminimize" }
                  end
              end,
    { description='restore minimized', group='client' }
  ),

}

-- Layout Keybindings {{{3

awful.keyboard.append_global_keybindings{
  awful.key({ 'Shift', mod }, 'j',
    function() awful.client.swap.byidx( 1) end,
    { description='swap with next client by index', group='client' }
  ),

  awful.key({ 'Shift', mod }, 'k',
    function() awful.client.swap.byidx( -1) end,
    { description='swap with previous client by index', group='client' }
  ),

  awful.key({ mod }, 'u',
    awful.client.urgent.jumpto,
    { description='jump to urgent client', group='client' }
  ),

  awful.key({ mod }, 'l',
    function() awful.tag.incmwfact( 0.05) end,
    { description='increase master width factor', group='layout' }
  ),

  awful.key({ mod }, 'h',
    function() awful.tag.incmwfact(-0.05) end,
    { description='decrease master width factor', group='layout' }
  ),

  awful.key({ 'Shift', mod }, 'h',
    function() awful.tag.incnmaster( 1, nil, true) end,
    { description='increase the number of master clients', group='layout' }
  ),

  awful.key({ 'Shift', mod }, 'l',
    function() awful.tag.incnmaster(-1, nil, true) end,
    { description='decrease the number of master clients', group='layout' }
  ),

  awful.key({ 'Control', mod }, 'h',
    function() awful.tag.incncol( 1, nil, true) end,
    { description='increase the number of columns', group='layout' }
  ),

  awful.key({ 'Control', mod }, 'l',
    function() awful.tag.incncol(-1, nil, true) end,
    { description='decrease the number of columns', group='layout' }
  ),

  awful.key({ mod }, 'space',
    function() awful.layout.inc( 1) end,
    { description='select next', group='layout' }
  ),

  awful.key({ 'Shift', mod }, 'space',
    function() awful.layout.inc(-1) end,
    { description='select previous', group='layout' }
  ),

}

client.connect_signal('request::default_mousebindings', function()
  awful.mouse.append_client_mousebindings{

    awful.button({}, 1, function(c)
      c:activate { context = 'mouse_click' }
    end),

    awful.button({ mod }, 1, function(c)
      c:activate { context = 'mouse_click', action = 'mouse_move' }
    end),

    awful.button({ mod }, 3, function(c)
      c:activate{ context = 'mouse_click', action = 'mouse_resize' }
    end),

  }
end)

client.connect_signal('request::default_keybindings', function()
  awful.keyboard.append_client_keybindings{

    awful.key({ mod }, 'f',
      function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
      end,
      { description='toggle fullscreen', group='client' }
    ),

    awful.key({ mod }, 'q',
      function(c) c:kill() end,
      { description='close', group='client' }
    ),

    awful.key({ 'Control', mod }, 'space',
      awful.client.floating.toggle,
      { description='toggle floating', group='client' }
    ),

    awful.key({ mod }, 'c',
      function(c)
        awful.placement.centered(c)
      end,
      { description='center', group='client' }
    ),

    awful.key({ 'Control', mod }, 'Return',
      function(c) c:swap(awful.client.getmaster()) end,
      { description='move to master', group='client' }
    ),

    awful.key({ mod }, 'o',
      function(c) c:move_to_screen() end,
      { description='move to screen', group='client' }
    ),

    awful.key({ mod }, 't',
      function(c) c.ontop = not c.ontop end,
      { description='toggle keep on top', group='client' }
    ),

    awful.key({ mod }, 'n',
      function(c)
        c.minimized = true
      end,
      { description='minimize', group='client' }
    ),

    awful.key({ mod }, 'm',
      function(c)
        c.maximized = not c.maximized
        c:raise()
      end,
      { description='(un)maximize', group='client' }
    ),

    awful.key({ 'Control', mod }, 'm',
      function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
      end,
      { description='(un)maximize vertically', group='client' }
    ),

    awful.key({ 'Shift', mod }, 'm',
      function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
      end,
      { description='(un)maximize horizontally', group='client' }
    ),

  }
end)

-- volume {{{3

awful.keyboard.append_global_keybindings{

  awful.key({ 'Mod1', mod }, 'h',
    function() awful.spawn('vol -Nt', false) end,
    { description='toggle mute', group='volume' }
  ),

  awful.key({ 'Mod1', mod }, 'j',
    function() awful.spawn('vol -Nd', false) end,
    { description='decrease volume 5%', group='volume' }
  ),

  awful.key({ 'Mod1', mod }, 'k',
    function() awful.spawn('vol -Ni', false) end,
    { description='increase volume 5%', group='volume' }
  ),

}


-- brightness {{{3

awful.keyboard.append_global_keybindings{

  awful.key({ 'Mod1', mod }, 'u',
    function() awful.spawn('light -S 0', false) end,
    { description = 'set brightness to min', group = 'brightness' }
  ),

  awful.key({ 'Mod1', mod }, 'i',
    function() awful.spawn('light -U 5', false) end,
    { description = 'decrease brightness by 5%', group = 'brightness' }
  ),

  awful.key({ 'Mod1', mod }, 'o',
    function() awful.spawn('light -A 5', false) end,
    { description = 'increase brightness by 5%', group = 'brightness' }
  ),

  awful.key({ 'Mod1', mod }, 'p',
    function() awful.spawn('light -S 100', false) end,
    { description = 'set brightness to max', group = 'brightness' }
  ),

  awful.key({ 'Mod1', mod }, 'r',
    function() awful.spawn('pkill -USR1 -x redshift', false) end,
    { description = 'toggle redshift', group = 'control' }
  ),

}

-- Screenshot {{{3

awful.keyboard.append_global_keybindings{

  awful.key({}, 'Print',
    function() awful.spawn.with_shell[[maim -q "$HOME/Pictures/Screenshot_$(date +'%Y-%m-%d %H:%M:%S').png"]] end,
    { description = 'Screenshot (full screen)', group = 'screenshot' }
  ),

  awful.key({ 'Shift' }, 'Print',
    function() awful.spawn.with_shell[[maim -qusko "$HOME/Pictures/Screenshot_$(date +'%Y-%m-%d %H:%M:%S').png"]] end,
    { description = 'Screenshot (selection)', group = 'screenshot' }
  ),

}

-- }}}3

-- }}}2

-- Rules {{{1

-- Defaults {{{2

ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule{
        id = "global",
        rule = {},
        properties = {
            focus = awful.client.focus.filter,
            raise = true,
            screen = awful.screen.preferred,
            size_hints_honor = false,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    }

    -- Floating clients.
    ruled.client.append_rule{
        id = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
            class = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester", -- xev.
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    }

    -- Add titlebars to normal clients and dialogs
    ruled.client.append_rule{
        id = "titlebars",
        rule_any = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = false }
    }

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- ruled.client.append_rule{
    -- rule = { class = "Firefox" },
    -- properties = { screen = 1, tag = "2" }
    -- }
end)

-- Titlebars {{{2

client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = {
    awful.button({}, 1, function()
      c:activate { context = "titlebar", action = "mouse_move" }
    end),
    awful.button({}, 3, function()
      c:activate { context = "titlebar", action = "mouse_resize"}
    end),
  }

  awful.titlebar(c, { size=25 }).widget = {
    {
      -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout = wibox.layout.fixed.horizontal,
    },
    {
      -- Middle
      {
        -- Title
        align = "center",
        widget = awful.titlebar.widget.titlewidget(c)
      },
      buttons = buttons,
      layout = wibox.layout.flex.horizontal
    },
    {
      -- Right
      awful.titlebar.widget.floatingbutton(c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton(c),
      awful.titlebar.widget.ontopbutton(c),
      awful.titlebar.widget.closebutton(c),
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal
  }
end)

-- Corners and Borders {{{2

local function corners(c)
  c.shape = function(cr, w, h)
    if c.fullscreen or c.maximized or c.maximized_horizontal and c.maximized_vertical then
      return gears.shape.rectangle(cr, w, h)
    else
      return gears.shape.rounded_rect(cr, w, h, 8)
    end
  end
  if not c.border then
    c.border_width = beautiful.border_width
  end
end

client.connect_signal('manage', corners)
client.connect_signal('property::maximized', corners)

client.connect_signal('property::geometry', function(c, ctx, hints)
  if c.floating and not c.float_centered then
    hints = awful.placement.centered(c)
    c.float_centered = true
  end
  awful.ewmh.client_geometry_requests(c, ctx, hints)
end)

-- Notifications {{{2

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule{
        rule = {},
        properties = {
            screen = awful.screen.preferred,
            implicit_timeout = 5,
        }
    }
end)

naughty.connect_signal("request::display", function(n)
    naughty.layout.box { notification = n }
end)

-- Enable sloppy focus, so that focus follows mouse. {{{2

client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)

-- }}}2

