Config { font = "Cantarell Mono Regular 12"
      , position = Top
      -- , borderColor = "#2e3440"
      -- , borderWidth = 2
      -- , border = BottomB
      , bgColor = "#2e3440"
      , fgColor = "#2aa198"
      , lowerOnStart = True
      , pickBroadest = False
      , persistent = False
      , hideOnStart = False
      , iconRoot = "/home/aluc/.config/xmobar/icons"
      , overrideRedirect = True
      , wmName = "xmobar2"
      , commands = [ Run Cpu [ "-t",         "<total>%"
                              ,"-l",         "#2e3440,#58e1ac"
                              ,"-L",         "20"
                              ,"-n",         "#4c566a,#58e1ac"
                              ,"-h",         "#cb4b16,#58e1ac"
                              ,"-H",         "50"
                              ,"-w",         "3"
                              ] 10

                    , Run Memory ["-t",          "<usedratio>%"
                                 ,"-l",          "#2e3440,#58e1ac"
                                 ,"-L",          "20"
                                 ,"-n",          "#4c566a,#58e1ac"
                                 ,"-h",          "#cb4b16,#58e1ac"
                                 ,"-H",          "50"
                                 ,"-w",          "2"
                                 ] 10

                    -- Focused window info
                    , Run Com "/home/aluc/.config/xmobar/scripts/winfo" ["-n"] "FWname" 3
                    , Run Com "/home/aluc/.config/xmobar/scripts/winfo" ["-t"] "FWtitle" 3
                    , Run Com "/home/aluc/.config/xmobar/scripts/winfo" ["-i"] "FWicon" 3
                    , Run Com "/home/aluc/.config/xmobar/scripts/checkupds" ["-i"] "updates" 3600
                    -- , Run ComX "$HOME/bin/cmusP" [] "" "cmus" 1
                    , Run Com "uname" ["-r"] "" 36000
                    , Run Date " %b %_d %Y - %H:%M:%S" "date" 10
                    , Run PipeReader "/home/aluc/.config/xmobar/scripts/volume-pipe" "vol"
                    , Run StdinReader
                    ]
      , sepChar = "%"
      , alignSep = "}{"


        -- COLORS 
        -- #2aa198  : Blue/green    -- fg
        --
        -- #d08770  : pinkish brown -- memory
        -- #ff00ff  : pink/purple   -- swap
        -- #828be6  : perrywinkle   -- FWname
        -- #825be6  : purpley       -- FWtitle
        -- bgColor = "#2e3440"
        -- fgColor = "#2aa198"
        -- #58e1ac

      , template = " \
      -- Left

      \<fc=#eceff4>%StdinReader% </fc>\

      \<fc=#b48ead,#2e3440></fc>\
      \<fc=#2e3440,#b48ead> %uname% </fc>\
      \<fc=#2e3440,#b48ead></fc>\

      \<fc=#58e1ac,#2e3440></fc>\
      \<fc=#2e3440,#58e1ac> %vol% </fc>\
      \<fc=#2e3440,#58e1ac></fc>\
      
      \<fc=#88c0d0,#2e3440></fc>\
      \<fc=#2e3440,#88c0d0><action=`dmenu_run` button=1> Dmenu </action></fc>\
      \<fc=#88c0d0></fc>\


      -- Centered
      \}\

      -- Right
      \{ \

      \<fc=#88c0d0,#2e3440></fc>\
      \<fc=#2e3440,#88c0d0> %updates% </fc>\
      \<fc=#88c0d0></fc>\

      \<fc=#2e3440,#58e1ac></fc>\
      \<fc=#2e3440,#58e1ac> %cpu% </fc>\
      \<fc=#2e3440,#58e1ac>%memory% </fc>\
      \<fc=#58e1ac></fc>\

      \<fc=#2e3440,#b48ead></fc>\
      \<fc=#2e3440,#b48ead> %date% </fc>\
      \<fc=#b48ead></fc> "

       }


