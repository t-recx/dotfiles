require("awful")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
require("naughty")
require("volume")
require("obvious.battery")

dofile(awful.util.getdir("config") .. "/" .. "error_handling.lua")

beautiful.init(awful.util.getdir("config") .. "/" .. "theme.lua")

home_path = os.getenv("HOME")
local_path = home_path .. "/local"
local_bin_path = local_path .. "/bin"
terminal = "sakura"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor
cmus_remote = local_bin_path .. "/cmus-remote"
lock_program = local_bin_path .. "/lockscreen"
systemctl = "systemctl -q --no-block"

modkey = "Mod4" -- Windows key

layouts =
{
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.spiral,
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier,
  awful.layout.suit.floating
}

tag_labels = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }
tags = {}
for s = 1, screen.count() do
  tags[s] = awful.tag(tag_labels, s, layouts[1])
end

dofile(awful.util.getdir("config") .. "/" .. "menus.lua")

launcher = awful.widget.launcher({ image = image(beautiful.awesome_icon), menu = main_menu })

textclock = awful.widget.textclock({ align = "right" })

systray = widget({ type = "systray" })

wibox = {}
promptbox = {}
layoutbox = {}

taglist = {}
taglist.buttons = awful.util.table.join(
awful.button({ }, 1, awful.tag.viewonly),
awful.button({ modkey }, 1, awful.client.movetotag),
awful.button({ }, 3, awful.tag.viewtoggle),
awful.button({ modkey }, 3, awful.client.toggletag)
)

tasklist = {}
tasklist.buttons = awful.util.table.join(
awful.button({ }, 1, function (c)
  if c == client.focus then
    c.minimized = true
  else
    if not c:isvisible() then
      awful.tag.viewonly(c:tags()[1])
    end

    client.focus = c
    c:raise()
  end
end),
awful.button({ }, 3, function ()
  if instance then
    instance:hide()
    instance = nil
  else
    instance = awful.menu.clients({ width=250 })
  end
end),
awful.button({ }, 4, function ()
  awful.client.focus.byidx(1)
  if client.focus then client.focus:raise() end
end),
awful.button({ }, 5, function ()
  awful.client.focus.byidx(-1)
  if client.focus then client.focus:raise() end
end))

for s = 1, screen.count() do
  promptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })

  layoutbox[s] = awful.widget.layoutbox(s)
  layoutbox[s]:buttons(awful.util.table.join(
  awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
  awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
  awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
  awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

  taglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, taglist.buttons)

  tasklist[s] = awful.widget.tasklist(function(c)
    return awful.widget.tasklist.label.currenttags(c, s)
  end, tasklist.buttons)


  wibox[s] = awful.wibox({ position = "top", screen = s })

  wibox[s].widgets = {
    {
      launcher,
      taglist[s],
      promptbox[s],
      layout = awful.widget.layout.horizontal.leftright
    },
    layoutbox[s],
    textclock,
    volume_widget,
    obvious.battery(),
    s == 1 and systray or nil,
    tasklist[s],
    layout = awful.widget.layout.horizontal.rightleft
  }
end

root.buttons(awful.util.table.join(
awful.button({ }, 3, function () main_menu:toggle() end)
))

globalkeys = awful.util.table.join(
awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

awful.key({ modkey,           }, "j",
function ()
  awful.client.focus.byidx( 1)
  if client.focus then client.focus:raise() end
end),
awful.key({ modkey,           }, "k",
function ()
  awful.client.focus.byidx(-1)
  if client.focus then client.focus:raise() end
end),
awful.key({ modkey,           }, "w", function () main_menu:show({keygrabber=true}) end),

awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
awful.key({ modkey,           }, "Tab",
function ()
  awful.client.focus.history.previous()
  if client.focus then
    client.focus:raise()
  end
end),

awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
awful.key({ modkey, "Control" }, "r", awesome.restart),
awful.key({ modkey, "Shift"   }, "q", awesome.quit),

awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

awful.key({ modkey, "Control" }, "n", awful.client.restore),

-- Prompt
awful.key({ modkey },            "r",     function () promptbox[mouse.screen]:run() end),

awful.key({ modkey }, "x",
function ()
  awful.prompt.run({ prompt = "Run Lua code: " },
  promptbox[mouse.screen].widget,
  awful.util.eval, nil,
  awful.util.getdir("cache") .. "/history_eval")
end)
)

clientkeys = awful.util.table.join(
awful.key({ modkey, }, "f", function (c) c.fullscreen = not c.fullscreen  end),
awful.key({ modkey, "Shift" }, "c", function (c) c:kill() end),
awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle),
awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
awful.key({ modkey, }, "o", awful.client.movetoscreen),
awful.key({ modkey, "Shift" }, "r", function (c) c:redraw() end),
awful.key({ modkey, }, "t", function (c) c.ontop = not c.ontop end),
awful.key({ modkey, }, "n", function (c) c.minimized = true end),
awful.key({ modkey, }, "\\", function() awful.util.spawn(lock_program) end),
awful.key({ }, "Print", function() awful.util.spawn("gnome-screenshot") end),
awful.key({ }, "XF86AudioPause", function() awful.util.spawn(cmus_remote .. " --pause", false) end),
awful.key({ }, "XF86AudioPlay", function() awful.util.spawn(cmus_remote .. " --pause", false) end),
awful.key({ }, "XF86AudioPrev", function() awful.util.spawn(cmus_remote .. " --prev", false) end),
awful.key({ }, "XF86AudioNext", function() awful.util.spawn(cmus_remote .. " --next", false) end),
awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer set Master 9%+", false) end),
awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer set Master 9%-", false) end),
awful.key({ }, "XF86AudioMute", function () awful.util.spawn("amixer set Master toggle", false) end),
awful.key({ modkey, }, "m", function (c)
  c.maximized_horizontal = not c.maximized_horizontal
  c.maximized_vertical   = not c.maximized_vertical
end)
)

for i = 1, table.getn(tag_labels) do
  globalkeys = awful.util.table.join(globalkeys,
  awful.key({ modkey }, tag_labels[i],
  function ()
    local screen = mouse.screen
    if tags[screen][i] then
      awful.tag.viewonly(tags[screen][i])
    end
  end),
  awful.key({ modkey, "Control" }, tag_labels[i],
  function ()
    local screen = mouse.screen
    if tags[screen][i] then
      awful.tag.viewtoggle(tags[screen][i])
    end
  end),
  awful.key({ modkey, "Shift" }, tag_labels[i],
  function ()
    if client.focus and tags[client.focus.screen][i] then
      awful.client.movetotag(tags[client.focus.screen][i])
    end
  end),
  awful.key({ modkey, "Control", "Shift" }, tag_labels[i],
  function ()
    if client.focus and tags[client.focus.screen][i] then
      awful.client.toggletag(tags[client.focus.screen][i])
    end
  end))
end

clientbuttons = awful.util.table.join(
awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
awful.button({ modkey }, 1, awful.mouse.client.move),
awful.button({ modkey }, 3, awful.mouse.client.resize)
)

root.keys(globalkeys)

awful.rules.rules = {
  { rule = { },
  properties = { border_width = beautiful.border_width,
  border_color = beautiful.border_normal,
  focus = true,
  keys = clientkeys,
  buttons = clientbuttons } },
  { rule = { class = "pinentry" },
  properties = { floating = true } },
  { rule = { class = "gimp" },
  properties = { floating = true } },
}

client.add_signal("manage", function (c, startup)
  -- Add a titlebar
  -- awful.titlebar.add(c, { modkey = modkey })

  c:add_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
      and awful.client.focus.filter(c) then
      client.focus = c
    end
  end)

  if not startup then
    if not c.size_hints.user_position and not c.size_hints.program_position then
      awful.placement.no_overlap(c)
      awful.placement.no_offscreen(c)
    end
  end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

awful.util.spawn_with_shell("synaptikscfg init")
awful.util.spawn_with_shell("xfce4-power-manager")
awful.util.spawn_with_shell("udisksctl mount -b /dev/sda1")
awful.util.spawn_with_shell(local_bin_path .. "/capslockescape")
