import XMonad

-- Actions
import qualified XMonad.Actions.CycleWS as CWS
import XMonad.Actions.NoBorders
import XMonad.Actions.SpawnOn

-- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, filterOutWsPP, wrap, xmobarPP, xmobarColor, shorten, shorten', shortenLeft', PP(..))
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.SetWMName
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP (xmobarFont)
import XMonad.Hooks.WorkspaceHistory

import XMonad.Layout.Gaps
import XMonad.Layout.PerWorkspace
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral

import qualified XMonad.StackSet as W
-- import XMonad.EZConfig (AddAdditionalKeysP)

-- Utils
import XMonad.Util.Cursor
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

-- Data
import Data.Maybe (fromJust)
import Data.Monoid
import qualified Data.Map        as M

import System.Exit
import System.IO

-- Variables
--
-- Default Terminal
myTerminal :: String
myTerminal = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = True

-- Width of the window border in pixels.
--
myBorderWidth = 2

myModMask = mod4Mask

-- myScratchPads :: [NamedScratchpad]
-- myScratchPads = [ NS "terminal" "kitty" (title =? "getScratched") defaultFloating ]
--
-- Workspaces
myWorkspaces = ["cab","web","lab","ser","gfx","idi","gam","muz","cha","hid"]
colorbg = "#2e3440"
colorfg = "#eceff4"

color01 = "#5e8bac"
color02 = "#b48ead"
color04 = "#ebcb8b"
color05 = "#81a1c1"
color09 = "#4c566a"
color17 = "#d03a3f"

leftwp = "<box type=Bottom width=2 mb=2 color=" ++ colorfg ++ ">"
rightwp = "</box>"

-- Count of window in active workspace
windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

------ COLORS

-- Border colors for unfocused and focused windows, respectively.
myNormalBorderColor  = color09
myFocusedBorderColor = color05

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        -- | (key, sc) <- zip [xK_e, xK_w, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:
myLayoutPrinter :: String -> String
myLayoutPrinter "Spacing Tall" = xmobarColor colorfg colorbg "til"
myLayoutPrinter "Spacing Mirror Tall" = xmobarColor colorfg colorbg "mti"
myLayoutPrinter "Spacing Spiral" = xmobarColor colorfg colorbg "fib"
myLayoutPrinter "Spacing Full" = xmobarColor colorfg colorbg "ful"
myLayoutPrinter x = xmobarColor colorfg colorbg x

myLayout =
    onWorkspace "gam" Full $
    avoidStruts(smartSpacing 2 $ tiled ||| Mirror tiled ||| fib ||| Full)
    where
        -- default tiling algorithm partitions the screen into two panes
        tiled   = Tall nmaster delta ratio
        -- The default number of windows in the master pane
        nmaster = 1
        -- Default proportion of screen occupied by master pane
        ratio   = 2/5
        -- Percent of screen to increment by when resizing panes
        delta   = 3/100

        fib     = spiral (6/7)
  

------------------------------------------------------------------------
-- Window rules:

myManageHook = composeAll
    [ 
    -- className =? "Gimp"           --> doFloat
    -- , className =? "Tilp"           --> doFloat
    -- , resource  =? "desktop_window" --> doIgnore
    -- , resource  =? "kdesktop"       --> doIgnore
    --
    className =? "discord" --> doShift "cha",
    className =? "Steam" --> doShift "gam"
    ]
-- <+> namedScratchpadManageHook myScratchPads


------------------------------------------------------------------------
-- Startup hook
myStartupHook = do

    setWMName "XMonad"

    setDefaultCursor xC_arrow

    spawnOnce "checkupdates | wc -l > /tmp/updates.tmp"
    spawnOnce "systemctl --user restart redshift.service"
    spawnOnce "unclutter --timeout 3 --jitter 50 -b"
    spawnOnce "numlockx"
    spawnOnce "$HOME/.config/xmonad/autostart/autostart.sh"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
    -- Setup xmobar as docks
    --
    xmproc0 <- spawnPipe "xmobar $HOME/.config/xmobar/xmobarrc0.hs"
    xmproc1 <- spawnPipe "xmobar $HOME/.config/xmobar/xmobarrc1.hs"

    -- ewmh: Add fullscreen handling support
    xmonad $ docks . ewmh $ defaults {
        layoutHook = avoidStruts $ layoutHook defaults
        , logHook = dynamicLogWithPP $ filterOutWsPP ["hid"] $ xmobarPP { 
             ppOutput = \x  -> hPutStrLn xmproc0 x

            , ppCurrent = xmobarColor colorfg colorbg . wrap leftwp rightwp -- Visible but not current workspace
            , ppVisible = xmobarColor colorfg colorbg -- Hidden workspace
            , ppHidden = xmobarColor color01 colorbg -- Hidden workspaces (no windows)
            , ppHiddenNoWindows = xmobarColor color04 colorbg -- Title of active window
            , ppTitle = xmobarColor "" "" . shorten' "" 0 -- Separator character
            , ppSep =  "  "
            , ppLayout = myLayoutPrinter
              -- Urgent workspace , ppUrgent = xmobarColor color17 colorbg . wrap "!" "!"
            , ppExtras  = [windowCount] -- Adding # of windows on current workspace to the bar
        }

}


defaults = ewmh def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook <+> manageSpawn,
        startupHook        = myStartupHook
        }
        `additionalKeysP`
        [ ("M-<Return>", spawn myTerminal)
        , ("M-n", spawn (myTerminal ++ " -e nvim"))
        , ("M-<Backspace>", withFocused hide) -- N.B. this is an absurd thing to do
        , ("M-0", windows $ W.greedyView $ "hid") -- N.B. this is an absurd thing to do
        , ("M-u",       incScreenWindowSpacing (2))
        , ("M-i",       incScreenWindowSpacing (-2))
        , ("M-o",       setScreenWindowSpacing (2))
        -- Then these key bindings
        -- cycling worspaces
        , ("M-<R>",     CWS.nextWS)
        , ("M-<L>",     CWS.prevWS)
        , ("M-S-<R>",   CWS.shiftToNext >> CWS.nextWS)
        , ("M-S-<L>",   CWS.shiftToPrev >> CWS.prevWS)
        , ("M-m",       spawn "emacs")
        -- launch firefox
        , ("M-b",       spawn "firefox")
        -- take screenshots
        , ("M-s",       spawn "maim ~/pictures/screenshot-$(date +%y%m%d_%H_%M_%S).png")
        , ("M-C-s",   spawn "maim -i $(xdotool getactivewindow) ~/pictures/screenshot-$(date +%y%m%d_%H_%M_%S).png")
        , ("M-S-s",     spawn "maim --select | xclip -selection clipboard -t image/png")
        -- close focused window
        , ("M-c",       spawn "kill $(xprop | grep PID | cut -d = -f 2)")
        , ("M-S-c",     kill)
         -- Rotate through the available layout algorithms
        , ("M-C-1", sendMessage $ JumpToLayout "Tall")
        , ("M-C-2", sendMessage $ JumpToLayout "Mirror Tall")
        , ("M-C-3", sendMessage $ JumpToLayout "Spiral")
        , ("M-C-4", sendMessage $ JumpToLayout "Full")
        , ("M-<Tab>", sendMessage NextLayout)

        , ("M-<Space>", spawn "cycleKB")
        -- Resize viewed windows to the correct size
        , ("M-f",       refresh) 
        -- Move focus to the next window
        , ("M-j",       windows W.focusDown)
        -- Move focus to the previous window
        , ("M-k",       windows W.focusUp) 
        -- Swap the focused window with the next window
        , ("M-S-j",     windows W.swapDown) 
        -- Swap the focused window with the previous window
        , ("M-S-k",     windows W.swapUp) 
        -- Shrink the master area
        , ("M-h",       sendMessage Shrink) 
        -- Expand the master area
        , ("M-l",       sendMessage Expand) 
        -- Push window back into tiling
        , ("M-S-t",     withFocused $ windows . W.sink) 
    -- Increment the number of windows in the master area
        , ("M-,",       sendMessage (IncMasterN 1)) 
        -- Deincrement the number of windows in the master area
        , ("M-.",       sendMessage (IncMasterN (-1))) 
        -- Quit xmonad
        , ("M-S-q",     io (exitWith ExitSuccess)) 
        -- Restart xmonad
        , ("M-q",       spawn "killall xmobar; xmonad --recompile && xmonad --restart") 
        , ("M-x m",       spawn "kill -USR1 $(pgrep xmobar)") 
        -- open alsamixer and change volume with keyboard wheel
        , ("<XF86AudioLowerVolume>" , spawn "pamixer -d 5")
        , ("<XF86AudioRaiseVolume>" , spawn "pamixer -i 5")
        , ("<XF86AudioMute>"        , spawn "pamixer -t")
        , ("<XF86MonBrightnessDown>", spawn "light -U 5")
        , ("<XF86MonBrightnessUp>"  , spawn "light -A 5")
        , ("M-y" , spawn "arr_hjkl")
        -- Toggle borders
        , ("M-S-b", do
            withFocused toggleBorder
            refresh)
        -- Fullscreen by toggling borders,
        -- struts so docks can be obfuscated
        -- (forcing it into tiling, because problems if you change layouts)
        , ("M-S-f", do
            sendMessage ToggleStruts
            sendMessage ToggleGaps
            toggleWindowSpacingEnabled
            withFocused toggleBorder
            refresh)
        
        , ("M-a c" , spawn "code")
        , ("M-a d" , spawnOn "cha" "discord")
        , ("M-a s" , spawnOn "cha" "signal-desktop")
        , ("M-a k" , spawn "virt-manager")
        , ("M-a m" , spawn "mumble")
        , ("M-a v" , spawn "virtualbox")

        -- cycle keyboards
        -- dmenu
        , ("M-S-<Return>", spawn "dmenu_run")
        , ("M-p a", spawn "dmapimg")
        , ("M-<Insert>", spawn "dmpsbm")
        , ("M-S-<Insert>", spawn "dmpsclip")
        , ("M-p c", spawn "dmclip")
        , ("M-p d", spawn "dmdsktp")
        , ("M-p f", spawn "dmfm")
        , ("M-p g", spawn "dmpassgen")
        , ("M-p h", spawn "dmhelp")
        , ("M-p l", spawn "dmlang")
        , ("M-p m", spawn "dmpass")
        -- , ("M-p S-m", spawn "passmenu --type")
        , ("M-p p", spawn "dmpdf")
        , ("M-p o", spawn "dmpower")
        , ("M-p v", spawn "dmvid")

        -- Gaming
        , ("M-g s", spawnOn "gam" "steam")
        , ("M-g m", spawnOn "gam" "multimc -l 1.8.9")
        ]
