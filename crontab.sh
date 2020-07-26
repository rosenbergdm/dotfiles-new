SHELL=/usr/local/bin/bash
MAILTO=davidrosenberg

@daily  /Users/davidrosenberg/bin/gmvault-runner.sh
@monthly  /Users/davidrosenberg/bin/backup_my_passwords.sh 2>&1 >> /var/log/backup_my_passwords.log
@daily  /Users/davidrosenberg/bin/dotfiles-check.sh
@daily  /usr/bin/rsync -arvh /Users/davidrosenberg/Box/ /Volumes/LaptopBackup2/uic-backups/Box
@daily  /Users/davidrosenberg/bin/gdrive-backup-runner.sh
@daily  /Users/davidrosenberg/bin/recreate_completions.sh
@daily /Users/davidrosenberg/src/radonchub-system/scripts/dump_pages.sh






# 17 * * * * /Users/davidrosenberg/bin/recreate_completions.sh
