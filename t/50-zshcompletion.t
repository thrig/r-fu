#!/usr/bin/env expect
#
# Messy due to mixed output with test terminal but appears to more or
# less confirm that at least the ZSH completion for "r-fu -\t" produces
# some expected output.

puts 1..1

set prompt "# "
set env(PS1) $prompt

set env(ZDOTDIR) .
if {[file exists .zcompdump]} { exec rm .zcompdump }

spawn -noecho zsh -f
# less terminal spam
#stty -echo
expect -ex $prompt

# find the _r-fu completion in this repo (but do need the global $fpath
# as that contains the function definition files for compinit itself...)
send -- "fpath=([pwd] \$fpath)\r"
expect -ex $prompt
# -C is to omit the various security checks on completion dirs
send -- "autoload -U compinit && compinit -C\r"

set tapout "not ok 1 - result not set by testing"

expect -ex $prompt
send -- {r-fu -}
send -- "\t"
expect {
    -ex "--width" {
        if {[regexp "display help for arlet" $expect_out(buffer)]} {
            set tapout "ok 1 - tab completion shows help"
        } else {
            set tapout "not ok 1 - tab completion help not found"
        }
    }
    -ex $prompt {
        set tapout "not ok 1 - unexpected return to prompt"
    }
    full_buffer {
        set tapout "not ok 1 - full buffer (did not see expected results)"
    }
    timeout {
        set tapout "not ok 1 - timeout (did not see expected results)"
    }
    eof {
        set tapout "not ok 1 - EOF on read"
    }
}
close
# KLUGE advance terminal so TAP result isn't hanging up in the tab
# completion output
puts ""
puts $tapout

if {[file exists .zcompdump]} { exec rm .zcompdump }
