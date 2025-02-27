# Code generated by zoxide. DO NOT EDIT.

# =============================================================================
#
# Utility functions for zoxide.
#

# Default prompt for Nushell.
def __zoxide_prompt [] {
    # if gstat plugin is installed could do `gstat | get branch`
    # let git = $'(do -i {git rev-parse --abbrev-ref HEAD} | decode utf-8 | str trim -r -c (char nl))'
    # let git = (if ($git | str length) == 0 { '' } else {
    #     build-string (char lp) (ansi cb) $git (ansi reset) (char rp)
    # })
    # build-string (ansi gb) ($nu.cwd) (ansi reset) $git '> '

    #if we really want the default prompt, we just need to hide the prompt to be sure
    hide PROMPT_COMMAND
    hide PROMPT_COMMAND_RIGHT
    hide PROMPT_INDICATOR
}

# =============================================================================
#
# Hook configuration for zoxide.
#

# Hook to add new entries to the database.
def __zoxide_hook [] {
    # shells | where active == $true | get path | each {
    #     zoxide add -- $it
    # }
    zoxide add -- (shells | where active == $true | get path | get 0)
}

# Initialize hook.

let-env ZOXIDE_INITIALIZED = (if ("ZOXIDE_INITIALIZED" not-in (env).name) {
    $false
} else {
    $env.ZOXIDE_INITIALIZED
})

let-env _OLD_PROMPT_COMMAND = (if $env.ZOXIDE_INITIALIZED {
    $env._OLD_PROMPT_COMMAND
} else {
    $env.PROMPT_COMMAND
})

# TODO
# the prompt hook I think will need to test the current prompt to see if it's
# a string or a block. If it's a string, prepend, if's a block, then wrap the
# call to that block in another block

let-env PROMPT_COMMAND = {
    __zoxide_hook  # gets executed in both cases

    if ("PROMPT_COMMAND" not-in (env).name)  {
        __zoxide_prompt   # run default prompt
    } else {
        do $env._OLD_PROMPT_COMMAND  # run the original prompt
    }
}

# =============================================================================
#
# When using zoxide with --no-aliases, alias these internal functions as
# desired.
#

# Jump to a directory using only keywords.
def-env __zoxide_z [...rest:string] {
    # if (shells | where active == $true) {
    #     if ($rest | length) > 1 {
    #         $'zoxide: can only jump in active shells(char nl)'
    #     } else {
    #         cd $rest
    #     }
    # } else {
        # let arg0 = ($rest | append '~' | first 1)
        # if ($rest | length) <= 1 && ($arg0 == '-' || ($arg0 | path expand | path exists)) {
        #     cd $arg0
        # } else {
            cd (zoxide query --exclude ($nu.cwd) -- $rest.0 | str collect | str trim)
        # }
    # }
}

# Jump to a directory using interactive search.
def-env __zoxide_zi  [...rest:string] {
    # if (shells | where active == $false) {
    #     $'zoxide: can only jump in active shells(char nl)'
    # } else {
        # cd $'(zoxide query -i -- $rest.0)'
        cd (zoxide query -i -- $rest.0 | str collect | str trim)
    # }
}

# =============================================================================
#
# Convenient aliases for zoxide. Disable these using --no-aliases.
#

alias z = __zoxide_z
alias zi = __zoxide_zi

# =============================================================================
#
# To initialize zoxide, add this to your configuration (find it by running
# `config path` in Nushell):
#
#   startup = ['zoxide init nushell --hook prompt | save ~/.zoxide.nu', 'source ~/.zoxide.nu']
#
# Note: zoxide only supports Nushell v0.37.0 and above.


# If everything went fine, set a flag that zoxide is initialized to avoid
# recursively calling _OLD_PROMPT_COMMAND
let-env ZOXIDE_INITIALIZED = $true
