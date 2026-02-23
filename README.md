# Trex Labs
Ansible roles & playbook that I use for my personal home setup.

I might miss/add stuff so I'll do my best to keep this readme updated

**Features:**
- Common base level packages I always use.
- dotfiles setup
- Create User(s)
- Caddy Install (Fedora/Debian) #TODO: Setup CadyFile config
- Docker Install
- Plex Install (Debian)
- Jellyfin Install (Debian)
- UFW Setup


## Setup/Install

Run requirements.yml:
`ansible-galaxy install -r requirements.yml`

requirements.yml
```yml
roles:
  - name: community.general
  # Role: create-user
  - name: ryandaniels.create_users
  # Role: dotfiles
  - name: geerlingguy.dotfiles
  # Role: Ansible-jellyfin 
  - name: Ansible-jellyfin
    src: https://github.com/Terell-Davis/ansible-jellyfin.git
```
Running my playbook: `ansible-playbook -i {inventory} trexlab-playbook.yml`

## Roles Used, Variables, & Files
### Common
- There is a shell script that gets copied to `/etc/profile.d/` from `roles/templates/motd.sh`. Enabled by default
```yml
- name: Install common packages & motd
  hosts: all
  roles:
    - common
  vars:
    enable_custom_profile_script: true
  become: true
```
- These are the current packages I have installing.
```yml
- sudo
- net-tools
- curl
- ufw
- htop
- samba
- unzip
- zip
- git

# Fedora specific for Ansible 
- python3-libdnf5
```

---
### [Create User(s)](https://github.com/jakob1379/ansible-role-create-users)
Need to create a secrets file to define user information. Plenty of examples on jakob1379 repo but here is an example of what I use.
In its current state this role will not run unless you have `ALLOW_BROKEN_CONDITIONALS = True` in your ansible.cfg file. If the pull request doesn't go through I will fork the repo with the change.

useradd example. Best to use `ansible-vault encrypt useradd` and edit ansible.cfg where to look for vault password. This is using information from the role repo.
```yml
users:
  - username: testuser
    password: {https://github.com/jakob1379/ansible-role-create-users?tab=readme-ov-file#how-to-generate-password}
    update_password: always
    comment: testuser - Main User
    groups: test
    shell: /bin/bash
    generate_ssh_key: yes
    use_sudo: yes
    use_sudo_nopass: no
    user_state: present
    servers:
      - all
```

Example in a playbook.
```yml
---
  name: Create User(s)
  hosts: all
  roles: 
    - ryandaniels.create_users
  vars_files:
    - ./useradd
  become: yes
```
---
### [dotfiles](https://github.com/geerlingguy/ansible-role-dotfiles)


Example in a playbook. This is using my dotfiles repo
```yml
- name: Installing dotfiles
  hosts: all
  roles:
    - geerlingguy.dotfiles
  vars:
    dotfiles_repo: "https://github.com/Terell-Davis/dotfiles.git"
    dotfiles_repo_version: master
    dotfiles_repo_local_destination: "~/Documents/dotfiles"
    dotfiles_home: "~"
    dotfiles_files:
      - .aliases
      - .bash_profile
      - .bash_prompt
      - .exports
      - .bashrc
```    
---
### [Caddy](https://github.com/nvjacobo/caddy)
Example in a playbook.
```yml
- name: Install Caddy Webserver
  hosts: web
  roles:
    - nvjacobo.caddy
  vars:
    caddy_package: caddy
    caddy_package_state: present
  become: true
```
---
### [Docker](https://github.com/geerlingguy/ansible-role-docker)

Example of how I use this in a playbook.
```yml
- name: Install Docker
  hosts: Test
  roles:
    -  geerlingguy.pip
    -  geerlingguy.docker
  vars:
   docker_users:
    - root
   pip_install_packages:
    - name:
        - docker
  become: true
```
---
### UFW
This role will always allow `Openssh`. The ports var is for any additional port.
Example in a playbook.
```yml
- name: Setup ufw
  hosts: secure
  roles:
    - ufw
  vars:
    ports:
      - 80
      - 443
      - 8080
  become: true
```
---
### Plex (Debian only for now)
Example in a playbook.
```yml
- name: Install Plex Server
  hosts: plexserver
  roles:
    - plex
  become: true
```
---
### [Jellyfin](https://github.com/Terell-Davis/ansible-jellyfin#) (Debian only for now)
Example in a playbook.
```yml
- name: Install Jellyfin Server
  hosts: jellyfinserver
  roles:
    - ansible-jellyfin
  vars:
    jellyfin_name: "jellyfin"
    jellyfin_group: "arcana"
    jellyfin_skip_restart: false
    jellyfin_enable_fail2ban: false
    jellyfin_fail2ban_ports:
    - "80"
    - "443"
    jellyfin_fail2ban_maxretry: "3"
    jellyfin_fail2ban_bantime: "6000"
    jellyfin_fail2ban_findtime: "600"

    jellyfin_cache_dir: "/var/cache/jellyfin"
    jellyfin_log_dir: "/var/log/jellyfin"
    jellyfin_config_dir: "/etc/jellyfin"
    jellyfin_data_dir: "/var/lib/jellyfin"

    jellyfin_ffmpeg_bin: "/usr/lib/jellyfin-ffmpeg/ffmpeg"
    jellyfin_web_bin: "/usr/share/jellyfin/web"
  become: true
```
---
## Contributing & Credits
### Contributes
  Contributions are welcomed!
### Credits
* [geerlingguy/ansible-role-dotfiles](https://github.com/geerlingguy/ansible-role-dotfiles)

* [nvjacobo/caddy](https://github.com/nvjacobo/caddy)

* [geerlingguy/ansible-role-docker](https://github.com/geerlingguy/ansible-role-docker)

* [jakob1379/ansible-role-create-users](https://github.com/jakob1379/ansible-role-create-users)

* [sleepy-nols/ansible-jellyfin](https://github.com/sleepy-nols/ansible-jellyfin)
  - My Fork: [Terell-Davis/ansible-jellyfin](https://github.com/Terell-Davis/ansible-jellyfin#)
---
## License
