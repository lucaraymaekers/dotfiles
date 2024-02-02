set from = "raymaekers.luca@gmail.com"
set realname = "Raymaekers Luca"
set my_pass = "`pass keys/tokens/gmail/raymaekers.luca@gmail.com`"

# IMAP settings
set imap_user = "raymaekers.luca@gmail.com"
set imap_pass = $my_pass

# SMTP settings
set smtp_url = "smtps://raymaekers.luca@smtp.gmail.com"
set smtp_pass = $my_pass

# Remote Gmail folders
set folder = "imaps://imap.gmail.com/"
set spoolfile = "+INBOX"
set postponed = "+[Gmail]/Drafts"
set record = "+[Gmail]/Sent Mail"
set trash = "+[Gmail]/Trash"

set header_cache = "~/.config/mutt/cache/headers"
set message_cachedir = "~/.config/mutt/cache/bodies"
set certificate_file = "~/.config/mutt/certificates"
set mbox_type = maildir

# Default color definitions
color normal     white         default
color hdrdefault green         default
color quoted     green         default
color quoted1    yellow        default
color quoted2    red           default
color signature  cyan          default
color indicator  brightyellow  red 
color error      brightred     default
color status     brightwhite   blue
color tree       brightmagenta default
color tilde      brightblue    default
color attachment brightyellow  magenta
color markers    brightred     default
color message    white         default
color search     brightwhite   magenta
color bold       brightyellow  green

# Color definitions when on a mono screen
mono bold      bold
mono underline underline
mono indicator reverse
mono error     bold

# Colors for items in the reader
color header brightyellow default "^(From|Subject):"
color header brightcyan   default ^To:
color header brightcyan   default ^Cc:
mono  header bold                 "^(From|Subject):"
