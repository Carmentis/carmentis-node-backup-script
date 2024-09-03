# Carmentis Node Backup module

This module provides a script to backup the Carmentis Node data files. The script creates a compressed archive of the `.carmentis/data` directory and saves it to the specified backup directory.

## Behavior
The script stops the Carmentis Node service, creates a compressed archive of the `.carmentis/data` directory, saves it to the `output` backup directory. The script then restarts the Carmentis Node service.

## Prerequisites
- unix-based operating system
- lz4
- tar
- cron (optional)

## Setup
1. Clone the repository and navigate to the directory where the `carmentis-backup.sh` file is located.
2. Make the script executable by running `chmod +x carmentis-backup.sh`.
3. Execute the script by running `./carmentis-backup.sh <running_node_directory>`.
4. To automate the backup process, you can set up a cron job to run the script at regular intervals.

## Restoring a Backup
To restore a backup,
1. Stop the Carmentis Node service.
2. Extract the contents of the backup archive to the `.carmentis/data` directory:
   ```bash
   lz4 -dc output/<backup_file>.tar.lz4 |  tar -xf - -C <running_node_directory>
   ```
3. Restart the Carmentis Node service.

## Additional Notes
This module will not back up the `.carmentis/config` directory. Ensure you have a backup of the configuration files in case you need to restore the Carmentis Node service.
