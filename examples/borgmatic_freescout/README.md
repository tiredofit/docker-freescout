After ssh keys are generated follow here else create the ssh key files at first! Otherwise it will not work!

1. Inital Borgmatic Repo
`docker compose exec borgmatic-freescout borgmatic init --encryption repokey-blake2`

2. Create manual backup
`docker compose exec borgmatic-freescout borgmatic -v 2`

3. Check your manual backup
`docker compose exec borgmatic-freescout borgmatic list`

If you see like here than you have a backup!
```
root@server:/opt/freescout/borgmatic_freescout# docker compose exec borgmatic-freescout borgmatic list
rsync: Listing archives
borgmatic-freescout-2024-03-24T00:14:56.041137 Sun, 2024-03-24 00:14:57 [dc7d36e4382867a06a1eee3d239ecd3df2d4d1e93750d6a3216bed20763421f9]
```

Your backup will now run according to crontab

Restore

1. To Restore just run this command next to your docker-compose.yml folder
`docker compose exec borgmatic-freescout borgmatic restore --archive latest`

2. Restart docker containers
`docker compose down && docker compose up`

Everything should be back!

I dont take any reponsibility for the backups! Its your risk!
