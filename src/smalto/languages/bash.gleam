import gleam/option
import smalto/grammar.{type Grammar, type Rule, Grammar}

pub fn grammar() -> Grammar {
  Grammar(name: "bash", extends: option.None, rules: rules())
}

fn rules() -> List(Rule) {
  [
    grammar.rule("important", "^#!\\s*\\/.*"),
    grammar.rule("comment", "(?:^|[^\"{\\\\$])\\K#.*"),
    grammar.rule(
      "function",
      "(?:\\bfunction\\s+)\\K[\\w-]+(?=(?:\\s*\\(?:\\s*\\))?\\s*\\{)",
    ),
    grammar.rule("function", "\\b[\\w-]+(?=\\s*\\(\\s*\\)\\s*\\{)"),
    grammar.rule("variable", "(?:\\b(?:for|select)\\s+)\\K\\w+(?=\\s+in\\s)"),
    grammar.rule_with_inside(
      "variable",
      "(?:^|[\\s;|&]|[<>]\\()\\K\\w+(?:\\.\\w+)*(?=\\+?=)",
      [
        grammar.rule(
          "constant",
          "(?:^|[\\s;|&]|[<>]\\()\\K\\b(?:BASH|BASHOPTS|BASH_ALIASES|BASH_ARGC|BASH_ARGV|BASH_CMDS|BASH_COMPLETION_COMPAT_DIR|BASH_LINENO|BASH_REMATCH|BASH_SOURCE|BASH_VERSINFO|BASH_VERSION|COLORTERM|COLUMNS|COMP_WORDBREAKS|DBUS_SESSION_BUS_ADDRESS|DEFAULTS_PATH|DESKTOP_SESSION|DIRSTACK|DISPLAY|EUID|GDMSESSION|GDM_LANG|GNOME_KEYRING_CONTROL|GNOME_KEYRING_PID|GPG_AGENT_INFO|GROUPS|HISTCONTROL|HISTFILE|HISTFILESIZE|HISTSIZE|HOME|HOSTNAME|HOSTTYPE|IFS|INSTANCE|JOB|LANG|LANGUAGE|LC_ADDRESS|LC_ALL|LC_IDENTIFICATION|LC_MEASUREMENT|LC_MONETARY|LC_NAME|LC_NUMERIC|LC_PAPER|LC_TELEPHONE|LC_TIME|LESSCLOSE|LESSOPEN|LINES|LOGNAME|LS_COLORS|MACHTYPE|MAILCHECK|MANDATORY_PATH|NO_AT_BRIDGE|OLDPWD|OPTERR|OPTIND|ORBIT_SOCKETDIR|OSTYPE|PAPERSIZE|PATH|PIPESTATUS|PPID|PS1|PS2|PS3|PS4|PWD|RANDOM|REPLY|SECONDS|SELINUX_INIT|SESSION|SESSIONTYPE|SESSION_MANAGER|SHELL|SHELLOPTS|SHLVL|SSH_AUTH_SOCK|TERM|UID|UPSTART_EVENTS|UPSTART_INSTANCE|UPSTART_JOB|UPSTART_SESSION|USER|WINDOWID|XAUTHORITY|XDG_CONFIG_DIRS|XDG_CURRENT_DESKTOP|XDG_DATA_DIRS|XDG_GREETER_DATA_DIR|XDG_MENU_PREFIX|XDG_RUNTIME_DIR|XDG_SEAT|XDG_SEAT_PATH|XDG_SESSION_DESKTOP|XDG_SESSION_ID|XDG_SESSION_PATH|XDG_SESSION_TYPE|XDG_VTNR|XMODIFIERS)\\b",
        ),
      ],
    ),
    grammar.rule(
      "variable",
      "(?:^|\\s)\\K-{1,2}(?:\\w+:[+-]?)?\\w+(?:\\.\\w+)*(?=[=\\s]|$)",
    ),
    grammar.greedy_rule_with_inside(
      "string",
      "(?:(?:^|[^<])<<-?\\s*)\\K(\\w+)\\s[\\s\\S]*?(?:\\r?\\n|\\r)\\2",
      [
        grammar.rule_with_inside(
          "punctuation",
          "(?:^([\"']?)\\w+\\2)\\K[ \\t]+\\S.*",
          [
            grammar.rule("important", "^#!\\s*\\/.*"),
            grammar.rule("comment", "(?:^|[^\"{\\\\$])\\K#.*"),
            grammar.rule(
              "function",
              "(?:\\bfunction\\s+)\\K[\\w-]+(?=(?:\\s*\\(?:\\s*\\))?\\s*\\{)",
            ),
            grammar.rule("function", "\\b[\\w-]+(?=\\s*\\(\\s*\\)\\s*\\{)"),
            grammar.rule(
              "variable",
              "(?:\\b(?:for|select)\\s+)\\K\\w+(?=\\s+in\\s)",
            ),
            grammar.rule(
              "variable",
              "(?:^|[\\s;|&]|[<>]\\()\\K\\w+(?:\\.\\w+)*(?=\\+?=)",
            ),
            grammar.rule(
              "variable",
              "(?:^|\\s)\\K-{1,2}(?:\\w+:[+-]?)?\\w+(?:\\.\\w+)*(?=[=\\s]|$)",
            ),
            grammar.greedy_rule(
              "string",
              "(?:(?:^|[^<])<<-?\\s*)\\K(\\w+)\\s[\\s\\S]*?(?:\\r?\\n|\\r)\\2",
            ),
            grammar.greedy_rule_with_inside(
              "string",
              "(?:(?:^|[^<])<<-?\\s*)\\K([\"'])(\\w+)\\2\\s[\\s\\S]*?(?:\\r?\\n|\\r)\\3",
              [
                grammar.rule(
                  "punctuation",
                  "(?:^([\"']?)\\w+\\2)\\K[ \\t]+\\S.*",
                ),
              ],
            ),
            grammar.greedy_rule(
              "string",
              "(?:^|[^\\\\](?:\\\\\\\\)*)\\K\"(?:\\\\[\\s\\S]|\\$\\([^)]+\\)|\\$(?!\\()|`[^`]+`|[^\"\\\\`$])*\"",
            ),
            grammar.greedy_rule("string", "(?:^|[^$\\\\])\\K'[^']*'"),
            grammar.greedy_rule_with_inside(
              "string",
              "\\$'(?:[^'\\\\]|\\\\[\\s\\S])*'",
              [
                grammar.rule(
                  "entity",
                  "\\\\(?:[abceEfnrtv\\\\\"]|O?[0-7]{1,3}|U[0-9a-fA-F]{8}|u[0-9a-fA-F]{4}|x[0-9a-fA-F]{1,2})",
                ),
              ],
            ),
            grammar.rule(
              "constant",
              "\\$?\\b(?:BASH|BASHOPTS|BASH_ALIASES|BASH_ARGC|BASH_ARGV|BASH_CMDS|BASH_COMPLETION_COMPAT_DIR|BASH_LINENO|BASH_REMATCH|BASH_SOURCE|BASH_VERSINFO|BASH_VERSION|COLORTERM|COLUMNS|COMP_WORDBREAKS|DBUS_SESSION_BUS_ADDRESS|DEFAULTS_PATH|DESKTOP_SESSION|DIRSTACK|DISPLAY|EUID|GDMSESSION|GDM_LANG|GNOME_KEYRING_CONTROL|GNOME_KEYRING_PID|GPG_AGENT_INFO|GROUPS|HISTCONTROL|HISTFILE|HISTFILESIZE|HISTSIZE|HOME|HOSTNAME|HOSTTYPE|IFS|INSTANCE|JOB|LANG|LANGUAGE|LC_ADDRESS|LC_ALL|LC_IDENTIFICATION|LC_MEASUREMENT|LC_MONETARY|LC_NAME|LC_NUMERIC|LC_PAPER|LC_TELEPHONE|LC_TIME|LESSCLOSE|LESSOPEN|LINES|LOGNAME|LS_COLORS|MACHTYPE|MAILCHECK|MANDATORY_PATH|NO_AT_BRIDGE|OLDPWD|OPTERR|OPTIND|ORBIT_SOCKETDIR|OSTYPE|PAPERSIZE|PATH|PIPESTATUS|PPID|PS1|PS2|PS3|PS4|PWD|RANDOM|REPLY|SECONDS|SELINUX_INIT|SESSION|SESSIONTYPE|SESSION_MANAGER|SHELL|SHELLOPTS|SHLVL|SSH_AUTH_SOCK|TERM|UID|UPSTART_EVENTS|UPSTART_INSTANCE|UPSTART_JOB|UPSTART_SESSION|USER|WINDOWID|XAUTHORITY|XDG_CONFIG_DIRS|XDG_CURRENT_DESKTOP|XDG_DATA_DIRS|XDG_GREETER_DATA_DIR|XDG_MENU_PREFIX|XDG_RUNTIME_DIR|XDG_SEAT|XDG_SEAT_PATH|XDG_SESSION_DESKTOP|XDG_SESSION_ID|XDG_SESSION_PATH|XDG_SESSION_TYPE|XDG_VTNR|XMODIFIERS)\\b",
            ),
            grammar.greedy_rule_with_inside(
              "variable",
              "\\$?\\(\\([\\s\\S]+?\\)\\)",
              [
                grammar.rule("variable", "(?:^\\$\\(\\([\\s\\S]+)\\K\\)\\)"),
                grammar.rule("variable", "^\\$\\(\\("),
                grammar.rule(
                  "number",
                  "\\b0x[\\dA-Fa-f]+\\b|(?:\\b\\d+(?:\\.\\d*)?|\\B\\.\\d+)(?:[Ee]-?\\d+)?",
                ),
                grammar.rule(
                  "operator",
                  "--|\\+\\+|\\*\\*=?|<<=?|>>=?|&&|\\|\\||[=!+\\-*/%<>^&|]=?|[?~:]",
                ),
                grammar.rule("punctuation", "\\(\\(?|\\)\\)?|,|;"),
              ],
            ),
            grammar.greedy_rule_with_inside(
              "variable",
              "\\$\\((?:\\([^)]+\\)|[^()])+\\)|`[^`]+`",
              [
                grammar.rule("variable", "^\\$\\(|^`|\\)$|`$"),
                grammar.rule("comment", "(?:^|[^\"{\\\\$])\\K#.*"),
                grammar.rule(
                  "function",
                  "(?:\\bfunction\\s+)\\K[\\w-]+(?=(?:\\s*\\(?:\\s*\\))?\\s*\\{)",
                ),
                grammar.rule("function", "\\b[\\w-]+(?=\\s*\\(\\s*\\)\\s*\\{)"),
                grammar.rule(
                  "variable",
                  "(?:\\b(?:for|select)\\s+)\\K\\w+(?=\\s+in\\s)",
                ),
                grammar.rule(
                  "variable",
                  "(?:^|[\\s;|&]|[<>]\\()\\K\\w+(?:\\.\\w+)*(?=\\+?=)",
                ),
                grammar.rule(
                  "variable",
                  "(?:^|\\s)\\K-{1,2}(?:\\w+:[+-]?)?\\w+(?:\\.\\w+)*(?=[=\\s]|$)",
                ),
                grammar.greedy_rule(
                  "string",
                  "(?:(?:^|[^<])<<-?\\s*)\\K(\\w+)\\s[\\s\\S]*?(?:\\r?\\n|\\r)\\2",
                ),
                grammar.greedy_rule(
                  "string",
                  "(?:(?:^|[^<])<<-?\\s*)\\K([\"'])(\\w+)\\2\\s[\\s\\S]*?(?:\\r?\\n|\\r)\\3",
                ),
                grammar.greedy_rule(
                  "string",
                  "(?:^|[^\\\\](?:\\\\\\\\)*)\\K\"(?:\\\\[\\s\\S]|\\$\\([^)]+\\)|\\$(?!\\()|`[^`]+`|[^\"\\\\`$])*\"",
                ),
                grammar.greedy_rule("string", "(?:^|[^$\\\\])\\K'[^']*'"),
                grammar.greedy_rule("string", "\\$'(?:[^'\\\\]|\\\\[\\s\\S])*'"),
                grammar.rule(
                  "constant",
                  "\\$?\\b(?:BASH|BASHOPTS|BASH_ALIASES|BASH_ARGC|BASH_ARGV|BASH_CMDS|BASH_COMPLETION_COMPAT_DIR|BASH_LINENO|BASH_REMATCH|BASH_SOURCE|BASH_VERSINFO|BASH_VERSION|COLORTERM|COLUMNS|COMP_WORDBREAKS|DBUS_SESSION_BUS_ADDRESS|DEFAULTS_PATH|DESKTOP_SESSION|DIRSTACK|DISPLAY|EUID|GDMSESSION|GDM_LANG|GNOME_KEYRING_CONTROL|GNOME_KEYRING_PID|GPG_AGENT_INFO|GROUPS|HISTCONTROL|HISTFILE|HISTFILESIZE|HISTSIZE|HOME|HOSTNAME|HOSTTYPE|IFS|INSTANCE|JOB|LANG|LANGUAGE|LC_ADDRESS|LC_ALL|LC_IDENTIFICATION|LC_MEASUREMENT|LC_MONETARY|LC_NAME|LC_NUMERIC|LC_PAPER|LC_TELEPHONE|LC_TIME|LESSCLOSE|LESSOPEN|LINES|LOGNAME|LS_COLORS|MACHTYPE|MAILCHECK|MANDATORY_PATH|NO_AT_BRIDGE|OLDPWD|OPTERR|OPTIND|ORBIT_SOCKETDIR|OSTYPE|PAPERSIZE|PATH|PIPESTATUS|PPID|PS1|PS2|PS3|PS4|PWD|RANDOM|REPLY|SECONDS|SELINUX_INIT|SESSION|SESSIONTYPE|SESSION_MANAGER|SHELL|SHELLOPTS|SHLVL|SSH_AUTH_SOCK|TERM|UID|UPSTART_EVENTS|UPSTART_INSTANCE|UPSTART_JOB|UPSTART_SESSION|USER|WINDOWID|XAUTHORITY|XDG_CONFIG_DIRS|XDG_CURRENT_DESKTOP|XDG_DATA_DIRS|XDG_GREETER_DATA_DIR|XDG_MENU_PREFIX|XDG_RUNTIME_DIR|XDG_SEAT|XDG_SEAT_PATH|XDG_SESSION_DESKTOP|XDG_SESSION_ID|XDG_SESSION_PATH|XDG_SESSION_TYPE|XDG_VTNR|XMODIFIERS)\\b",
                ),
                grammar.rule(
                  "function",
                  "(?:^|[\\s;|&]|[<>]\\()\\K(?:add|apropos|apt|apt-cache|apt-get|aptitude|aspell|automysqlbackup|awk|basename|bash|bc|bconsole|bg|bzip2|cal|cargo|cat|cfdisk|chgrp|chkconfig|chmod|chown|chroot|cksum|clear|cmp|column|comm|composer|cp|cron|crontab|csplit|curl|cut|date|dc|dd|ddrescue|debootstrap|df|diff|diff3|dig|dir|dircolors|dirname|dirs|dmesg|docker|docker-compose|du|egrep|eject|env|ethtool|expand|expect|expr|fdformat|fdisk|fg|fgrep|file|find|fmt|fold|format|free|fsck|ftp|fuser|gawk|git|gparted|grep|groupadd|groupdel|groupmod|groups|grub-mkconfig|gzip|halt|head|hg|history|host|hostname|htop|iconv|id|ifconfig|ifdown|ifup|import|install|ip|java|jobs|join|kill|killall|less|link|ln|locate|logname|logrotate|look|lpc|lpr|lprint|lprintd|lprintq|lprm|ls|lsof|lynx|make|man|mc|mdadm|mkconfig|mkdir|mke2fs|mkfifo|mkfs|mkisofs|mknod|mkswap|mmv|more|most|mount|mtools|mtr|mutt|mv|nano|nc|netstat|nice|nl|node|nohup|notify-send|npm|nslookup|op|open|parted|passwd|paste|pathchk|ping|pkill|pnpm|podman|podman-compose|popd|pr|printcap|printenv|ps|pushd|pv|quota|quotacheck|quotactl|ram|rar|rcp|reboot|remsync|rename|renice|rev|rm|rmdir|rpm|rsync|scp|screen|sdiff|sed|sendmail|seq|service|sftp|sh|shellcheck|shuf|shutdown|sleep|slocate|sort|split|ssh|stat|strace|su|sudo|sum|suspend|swapon|sync|sysctl|tac|tail|tar|tee|time|timeout|top|touch|tr|traceroute|tsort|tty|umount|uname|unexpand|uniq|units|unrar|unshar|unzip|update-grub|uptime|useradd|userdel|usermod|users|uudecode|uuencode|v|vcpkg|vdir|vi|vim|virsh|vmstat|wait|watch|wc|wget|whereis|which|who|whoami|write|xargs|xdg-open|yarn|yes|zenity|zip|zsh|zypper)(?=$|[)\\s;|&])",
                ),
                grammar.rule(
                  "keyword",
                  "(?:^|[\\s;|&]|[<>]\\()\\K(?:case|do|done|elif|else|esac|fi|for|function|if|in|select|then|until|while)(?=$|[)\\s;|&])",
                ),
                grammar.rule(
                  "class-name",
                  "(?:^|[\\s;|&]|[<>]\\()\\K(?:\\.|:|alias|bind|break|builtin|caller|cd|command|continue|declare|echo|enable|eval|exec|exit|export|getopts|hash|help|let|local|logout|mapfile|printf|pwd|read|readarray|readonly|return|set|shift|shopt|source|test|times|trap|type|typeset|ulimit|umask|unalias|unset)(?=$|[)\\s;|&])",
                ),
                grammar.rule(
                  "boolean",
                  "(?:^|[\\s;|&]|[<>]\\()\\K(?:false|true)(?=$|[)\\s;|&])",
                ),
                grammar.rule("important", "\\B&\\d\\b"),
                grammar.rule_with_inside(
                  "operator",
                  "\\d?<>|>\\||\\+=|=[=~]?|!=?|<<[<-]?|[&\\d]?>>|\\d[<>]&?|[<>][&=]?|&[>&]?|\\|[&|]?",
                  [
                    grammar.rule("important", "^\\d"),
                  ],
                ),
                grammar.rule(
                  "punctuation",
                  "\\$?\\(\\(?|\\)\\)?|\\.\\.|[{}[\\];\\\\]",
                ),
                grammar.rule(
                  "number",
                  "(?:^|\\s)\\K(?:[1-9]\\d*|0)(?:[.,]\\d+)?\\b",
                ),
              ],
            ),
            grammar.greedy_rule_with_inside("variable", "\\$\\{[^}]+\\}", [
              grammar.rule("operator", ":[-=?+]?|[!\\/]|##?|%%?|\\^\\^?|,,?"),
              grammar.rule("punctuation", "[\\[\\]]"),
              grammar.rule(
                "constant",
                "(?<=\\{)\\b(?:BASH|BASHOPTS|BASH_ALIASES|BASH_ARGC|BASH_ARGV|BASH_CMDS|BASH_COMPLETION_COMPAT_DIR|BASH_LINENO|BASH_REMATCH|BASH_SOURCE|BASH_VERSINFO|BASH_VERSION|COLORTERM|COLUMNS|COMP_WORDBREAKS|DBUS_SESSION_BUS_ADDRESS|DEFAULTS_PATH|DESKTOP_SESSION|DIRSTACK|DISPLAY|EUID|GDMSESSION|GDM_LANG|GNOME_KEYRING_CONTROL|GNOME_KEYRING_PID|GPG_AGENT_INFO|GROUPS|HISTCONTROL|HISTFILE|HISTFILESIZE|HISTSIZE|HOME|HOSTNAME|HOSTTYPE|IFS|INSTANCE|JOB|LANG|LANGUAGE|LC_ADDRESS|LC_ALL|LC_IDENTIFICATION|LC_MEASUREMENT|LC_MONETARY|LC_NAME|LC_NUMERIC|LC_PAPER|LC_TELEPHONE|LC_TIME|LESSCLOSE|LESSOPEN|LINES|LOGNAME|LS_COLORS|MACHTYPE|MAILCHECK|MANDATORY_PATH|NO_AT_BRIDGE|OLDPWD|OPTERR|OPTIND|ORBIT_SOCKETDIR|OSTYPE|PAPERSIZE|PATH|PIPESTATUS|PPID|PS1|PS2|PS3|PS4|PWD|RANDOM|REPLY|SECONDS|SELINUX_INIT|SESSION|SESSIONTYPE|SESSION_MANAGER|SHELL|SHELLOPTS|SHLVL|SSH_AUTH_SOCK|TERM|UID|UPSTART_EVENTS|UPSTART_INSTANCE|UPSTART_JOB|UPSTART_SESSION|USER|WINDOWID|XAUTHORITY|XDG_CONFIG_DIRS|XDG_CURRENT_DESKTOP|XDG_DATA_DIRS|XDG_GREETER_DATA_DIR|XDG_MENU_PREFIX|XDG_RUNTIME_DIR|XDG_SEAT|XDG_SEAT_PATH|XDG_SESSION_DESKTOP|XDG_SESSION_ID|XDG_SESSION_PATH|XDG_SESSION_TYPE|XDG_VTNR|XMODIFIERS)\\b",
              ),
            ]),
            grammar.rule("variable", "\\$(?:\\w+|[#?*!@$])"),
            grammar.rule(
              "function",
              "(?:^|[\\s;|&]|[<>]\\()\\K(?:add|apropos|apt|apt-cache|apt-get|aptitude|aspell|automysqlbackup|awk|basename|bash|bc|bconsole|bg|bzip2|cal|cargo|cat|cfdisk|chgrp|chkconfig|chmod|chown|chroot|cksum|clear|cmp|column|comm|composer|cp|cron|crontab|csplit|curl|cut|date|dc|dd|ddrescue|debootstrap|df|diff|diff3|dig|dir|dircolors|dirname|dirs|dmesg|docker|docker-compose|du|egrep|eject|env|ethtool|expand|expect|expr|fdformat|fdisk|fg|fgrep|file|find|fmt|fold|format|free|fsck|ftp|fuser|gawk|git|gparted|grep|groupadd|groupdel|groupmod|groups|grub-mkconfig|gzip|halt|head|hg|history|host|hostname|htop|iconv|id|ifconfig|ifdown|ifup|import|install|ip|java|jobs|join|kill|killall|less|link|ln|locate|logname|logrotate|look|lpc|lpr|lprint|lprintd|lprintq|lprm|ls|lsof|lynx|make|man|mc|mdadm|mkconfig|mkdir|mke2fs|mkfifo|mkfs|mkisofs|mknod|mkswap|mmv|more|most|mount|mtools|mtr|mutt|mv|nano|nc|netstat|nice|nl|node|nohup|notify-send|npm|nslookup|op|open|parted|passwd|paste|pathchk|ping|pkill|pnpm|podman|podman-compose|popd|pr|printcap|printenv|ps|pushd|pv|quota|quotacheck|quotactl|ram|rar|rcp|reboot|remsync|rename|renice|rev|rm|rmdir|rpm|rsync|scp|screen|sdiff|sed|sendmail|seq|service|sftp|sh|shellcheck|shuf|shutdown|sleep|slocate|sort|split|ssh|stat|strace|su|sudo|sum|suspend|swapon|sync|sysctl|tac|tail|tar|tee|time|timeout|top|touch|tr|traceroute|tsort|tty|umount|uname|unexpand|uniq|units|unrar|unshar|unzip|update-grub|uptime|useradd|userdel|usermod|users|uudecode|uuencode|v|vcpkg|vdir|vi|vim|virsh|vmstat|wait|watch|wc|wget|whereis|which|who|whoami|write|xargs|xdg-open|yarn|yes|zenity|zip|zsh|zypper)(?=$|[)\\s;|&])",
            ),
            grammar.rule(
              "keyword",
              "(?:^|[\\s;|&]|[<>]\\()\\K(?:case|do|done|elif|else|esac|fi|for|function|if|in|select|then|until|while)(?=$|[)\\s;|&])",
            ),
            grammar.rule(
              "class-name",
              "(?:^|[\\s;|&]|[<>]\\()\\K(?:\\.|:|alias|bind|break|builtin|caller|cd|command|continue|declare|echo|enable|eval|exec|exit|export|getopts|hash|help|let|local|logout|mapfile|printf|pwd|read|readarray|readonly|return|set|shift|shopt|source|test|times|trap|type|typeset|ulimit|umask|unalias|unset)(?=$|[)\\s;|&])",
            ),
            grammar.rule(
              "boolean",
              "(?:^|[\\s;|&]|[<>]\\()\\K(?:false|true)(?=$|[)\\s;|&])",
            ),
            grammar.rule("important", "\\B&\\d\\b"),
            grammar.rule(
              "operator",
              "\\d?<>|>\\||\\+=|=[=~]?|!=?|<<[<-]?|[&\\d]?>>|\\d[<>]&?|[<>][&=]?|&[>&]?|\\|[&|]?",
            ),
            grammar.rule(
              "punctuation",
              "\\$?\\(\\(?|\\)\\)?|\\.\\.|[{}[\\];\\\\]",
            ),
            grammar.rule(
              "number",
              "(?:^|\\s)\\K(?:[1-9]\\d*|0)(?:[.,]\\d+)?\\b",
            ),
          ],
        ),
        grammar.rule(
          "constant",
          "\\$\\b(?:BASH|BASHOPTS|BASH_ALIASES|BASH_ARGC|BASH_ARGV|BASH_CMDS|BASH_COMPLETION_COMPAT_DIR|BASH_LINENO|BASH_REMATCH|BASH_SOURCE|BASH_VERSINFO|BASH_VERSION|COLORTERM|COLUMNS|COMP_WORDBREAKS|DBUS_SESSION_BUS_ADDRESS|DEFAULTS_PATH|DESKTOP_SESSION|DIRSTACK|DISPLAY|EUID|GDMSESSION|GDM_LANG|GNOME_KEYRING_CONTROL|GNOME_KEYRING_PID|GPG_AGENT_INFO|GROUPS|HISTCONTROL|HISTFILE|HISTFILESIZE|HISTSIZE|HOME|HOSTNAME|HOSTTYPE|IFS|INSTANCE|JOB|LANG|LANGUAGE|LC_ADDRESS|LC_ALL|LC_IDENTIFICATION|LC_MEASUREMENT|LC_MONETARY|LC_NAME|LC_NUMERIC|LC_PAPER|LC_TELEPHONE|LC_TIME|LESSCLOSE|LESSOPEN|LINES|LOGNAME|LS_COLORS|MACHTYPE|MAILCHECK|MANDATORY_PATH|NO_AT_BRIDGE|OLDPWD|OPTERR|OPTIND|ORBIT_SOCKETDIR|OSTYPE|PAPERSIZE|PATH|PIPESTATUS|PPID|PS1|PS2|PS3|PS4|PWD|RANDOM|REPLY|SECONDS|SELINUX_INIT|SESSION|SESSIONTYPE|SESSION_MANAGER|SHELL|SHELLOPTS|SHLVL|SSH_AUTH_SOCK|TERM|UID|UPSTART_EVENTS|UPSTART_INSTANCE|UPSTART_JOB|UPSTART_SESSION|USER|WINDOWID|XAUTHORITY|XDG_CONFIG_DIRS|XDG_CURRENT_DESKTOP|XDG_DATA_DIRS|XDG_GREETER_DATA_DIR|XDG_MENU_PREFIX|XDG_RUNTIME_DIR|XDG_SEAT|XDG_SEAT_PATH|XDG_SESSION_DESKTOP|XDG_SESSION_ID|XDG_SESSION_PATH|XDG_SESSION_TYPE|XDG_VTNR|XMODIFIERS)\\b",
        ),
        grammar.greedy_rule("variable", "\\$?\\(\\([\\s\\S]+?\\)\\)"),
        grammar.greedy_rule(
          "variable",
          "\\$\\((?:\\([^)]+\\)|[^()])+\\)|`[^`]+`",
        ),
        grammar.greedy_rule("variable", "\\$\\{[^}]+\\}"),
        grammar.rule("variable", "\\$(?:\\w+|[#?*!@$])"),
        grammar.rule(
          "entity",
          "\\\\(?:[abceEfnrtv\\\\\"]|O?[0-7]{1,3}|U[0-9a-fA-F]{8}|u[0-9a-fA-F]{4}|x[0-9a-fA-F]{1,2})",
        ),
      ],
    ),
    grammar.greedy_rule(
      "string",
      "(?:(?:^|[^<])<<-?\\s*)\\K([\"'])(\\w+)\\2\\s[\\s\\S]*?(?:\\r?\\n|\\r)\\3",
    ),
    grammar.greedy_rule(
      "string",
      "(?:^|[^\\\\](?:\\\\\\\\)*)\\K\"(?:\\\\[\\s\\S]|\\$\\([^)]+\\)|\\$(?!\\()|`[^`]+`|[^\"\\\\`$])*\"",
    ),
    grammar.greedy_rule("string", "(?:^|[^$\\\\])\\K'[^']*'"),
    grammar.greedy_rule("string", "\\$'(?:[^'\\\\]|\\\\[\\s\\S])*'"),
    grammar.rule(
      "constant",
      "\\$?\\b(?:BASH|BASHOPTS|BASH_ALIASES|BASH_ARGC|BASH_ARGV|BASH_CMDS|BASH_COMPLETION_COMPAT_DIR|BASH_LINENO|BASH_REMATCH|BASH_SOURCE|BASH_VERSINFO|BASH_VERSION|COLORTERM|COLUMNS|COMP_WORDBREAKS|DBUS_SESSION_BUS_ADDRESS|DEFAULTS_PATH|DESKTOP_SESSION|DIRSTACK|DISPLAY|EUID|GDMSESSION|GDM_LANG|GNOME_KEYRING_CONTROL|GNOME_KEYRING_PID|GPG_AGENT_INFO|GROUPS|HISTCONTROL|HISTFILE|HISTFILESIZE|HISTSIZE|HOME|HOSTNAME|HOSTTYPE|IFS|INSTANCE|JOB|LANG|LANGUAGE|LC_ADDRESS|LC_ALL|LC_IDENTIFICATION|LC_MEASUREMENT|LC_MONETARY|LC_NAME|LC_NUMERIC|LC_PAPER|LC_TELEPHONE|LC_TIME|LESSCLOSE|LESSOPEN|LINES|LOGNAME|LS_COLORS|MACHTYPE|MAILCHECK|MANDATORY_PATH|NO_AT_BRIDGE|OLDPWD|OPTERR|OPTIND|ORBIT_SOCKETDIR|OSTYPE|PAPERSIZE|PATH|PIPESTATUS|PPID|PS1|PS2|PS3|PS4|PWD|RANDOM|REPLY|SECONDS|SELINUX_INIT|SESSION|SESSIONTYPE|SESSION_MANAGER|SHELL|SHELLOPTS|SHLVL|SSH_AUTH_SOCK|TERM|UID|UPSTART_EVENTS|UPSTART_INSTANCE|UPSTART_JOB|UPSTART_SESSION|USER|WINDOWID|XAUTHORITY|XDG_CONFIG_DIRS|XDG_CURRENT_DESKTOP|XDG_DATA_DIRS|XDG_GREETER_DATA_DIR|XDG_MENU_PREFIX|XDG_RUNTIME_DIR|XDG_SEAT|XDG_SEAT_PATH|XDG_SESSION_DESKTOP|XDG_SESSION_ID|XDG_SESSION_PATH|XDG_SESSION_TYPE|XDG_VTNR|XMODIFIERS)\\b",
    ),
    grammar.greedy_rule("variable", "\\$?\\(\\([\\s\\S]+?\\)\\)"),
    grammar.greedy_rule("variable", "\\$\\((?:\\([^)]+\\)|[^()])+\\)|`[^`]+`"),
    grammar.greedy_rule("variable", "\\$\\{[^}]+\\}"),
    grammar.rule("variable", "\\$(?:\\w+|[#?*!@$])"),
    grammar.rule(
      "function",
      "(?:^|[\\s;|&]|[<>]\\()\\K(?:add|apropos|apt|apt-cache|apt-get|aptitude|aspell|automysqlbackup|awk|basename|bash|bc|bconsole|bg|bzip2|cal|cargo|cat|cfdisk|chgrp|chkconfig|chmod|chown|chroot|cksum|clear|cmp|column|comm|composer|cp|cron|crontab|csplit|curl|cut|date|dc|dd|ddrescue|debootstrap|df|diff|diff3|dig|dir|dircolors|dirname|dirs|dmesg|docker|docker-compose|du|egrep|eject|env|ethtool|expand|expect|expr|fdformat|fdisk|fg|fgrep|file|find|fmt|fold|format|free|fsck|ftp|fuser|gawk|git|gparted|grep|groupadd|groupdel|groupmod|groups|grub-mkconfig|gzip|halt|head|hg|history|host|hostname|htop|iconv|id|ifconfig|ifdown|ifup|import|install|ip|java|jobs|join|kill|killall|less|link|ln|locate|logname|logrotate|look|lpc|lpr|lprint|lprintd|lprintq|lprm|ls|lsof|lynx|make|man|mc|mdadm|mkconfig|mkdir|mke2fs|mkfifo|mkfs|mkisofs|mknod|mkswap|mmv|more|most|mount|mtools|mtr|mutt|mv|nano|nc|netstat|nice|nl|node|nohup|notify-send|npm|nslookup|op|open|parted|passwd|paste|pathchk|ping|pkill|pnpm|podman|podman-compose|popd|pr|printcap|printenv|ps|pushd|pv|quota|quotacheck|quotactl|ram|rar|rcp|reboot|remsync|rename|renice|rev|rm|rmdir|rpm|rsync|scp|screen|sdiff|sed|sendmail|seq|service|sftp|sh|shellcheck|shuf|shutdown|sleep|slocate|sort|split|ssh|stat|strace|su|sudo|sum|suspend|swapon|sync|sysctl|tac|tail|tar|tee|time|timeout|top|touch|tr|traceroute|tsort|tty|umount|uname|unexpand|uniq|units|unrar|unshar|unzip|update-grub|uptime|useradd|userdel|usermod|users|uudecode|uuencode|v|vcpkg|vdir|vi|vim|virsh|vmstat|wait|watch|wc|wget|whereis|which|who|whoami|write|xargs|xdg-open|yarn|yes|zenity|zip|zsh|zypper)(?=$|[)\\s;|&])",
    ),
    grammar.rule(
      "keyword",
      "(?:^|[\\s;|&]|[<>]\\()\\K(?:case|do|done|elif|else|esac|fi|for|function|if|in|select|then|until|while)(?=$|[)\\s;|&])",
    ),
    grammar.rule(
      "class-name",
      "(?:^|[\\s;|&]|[<>]\\()\\K(?:\\.|:|alias|bind|break|builtin|caller|cd|command|continue|declare|echo|enable|eval|exec|exit|export|getopts|hash|help|let|local|logout|mapfile|printf|pwd|read|readarray|readonly|return|set|shift|shopt|source|test|times|trap|type|typeset|ulimit|umask|unalias|unset)(?=$|[)\\s;|&])",
    ),
    grammar.rule(
      "boolean",
      "(?:^|[\\s;|&]|[<>]\\()\\K(?:false|true)(?=$|[)\\s;|&])",
    ),
    grammar.rule("important", "\\B&\\d\\b"),
    grammar.rule(
      "operator",
      "\\d?<>|>\\||\\+=|=[=~]?|!=?|<<[<-]?|[&\\d]?>>|\\d[<>]&?|[<>][&=]?|&[>&]?|\\|[&|]?",
    ),
    grammar.rule("punctuation", "\\$?\\(\\(?|\\)\\)?|\\.\\.|[{}[\\];\\\\]"),
    grammar.rule("number", "(?:^|\\s)\\K(?:[1-9]\\d*|0)(?:[.,]\\d+)?\\b"),
  ]
}
