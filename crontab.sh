SHELL=/usr/local/bin/bash
MAILTO=davidrosenberg

@daily  /Users/davidrosenberg/bin/gmvault-runner.sh
@monthly  /Users/davidrosenberg/bin/backup_my_passwords.sh 2>&1 >> /var/log/backup_my_passwords.log
@daily  /Users/davidrosenberg/bin/dotfiles-check.sh




