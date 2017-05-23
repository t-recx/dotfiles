doom_path = home_path .. "/gzdoom_build/gzdoom/build"

games_menu = {
  { "brutal doom", doom_path .. "/gzdoom -file " .. doom_path .. "/bd.pk3 " .. doom_path .. "/WAD/IDKFAv2.wad" },
  { "morrowind", home_path .. "/Games/openmw/build/openmw-launcher" },
  { "steam", "steam" },
}

main_menu = awful.menu({ items = { 

  { "terminal", terminal },
  { "chrome", "google-chrome" },
  { "incognito", "google-chrome --incognito" },
  { "irc", terminal .. " -e " .. local_bin_path .. "/weechat" },
  { "gvim", "gvim" },
  { "kodi", "kodi" },
  { "files", "nautilus" },
  { "packages", "gksudo synaptic-pkexec" },
  { "cmus", terminal .. " -e " .. local_bin_path .. "/cmus" },
  { "aseprite", "aseprite" },
  { "torrents", terminal .. " -e rtorrent" },
  { "spotify", "/opt/google/chrome/google-chrome --profile-directory=Default --app-id=kfbnhhcmmpmjfkkakaplojljcodkmobo" },
  { "games", games_menu },
  { "settings", "gnome-control-center" },
  { "restart", awesome.restart },
  { "lock", lock_program },
  { "quit", awesome.quit },
  { "reboot", systemctl .. " reboot" },
  { "shutdown", systemctl .. " poweroff" }
}
})

