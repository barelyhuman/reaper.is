---

title: Checklist for Macbook Setup
published: true
date: 2021-02-05T12:27:01.493Z
---

I wipe my Macbook quite often as a chore, this is done once every 4-5 months and helps me get rid of stuff on the SSD that I probably don't use anymore but is there just because I'm not browsing throught the entire SSD.

This isn't a blog type post but more like a checklist of things that I need to make sure I do before I send everything on the drive to hell.

### Pre - Wipe

Things before wiping the system.

- <input type="checkbox" class="task-item "/> Backup .ssh folder, them keys are important!
- <input type="checkbox" class="task-item "/> Make sure you make a timecapsule backup to an external ssd / flash drive
- <input type="checkbox" class="task-item "/> Move notes from various folders to the SSD, (make a good notes app idiot!, stop putting everything here and there on the system)
- <input type="checkbox" class="task-item "/> Don't forget getting the vimrc and vscode config, update an existing gist or for the sake of god be a little more smarter and put them up on your website, the collections section is there for a reason.

### Post - Wipe

- <input type="checkbox" class="task-item "/> Setup Homebrew

  ```sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```

- <input type="checkbox" class="task-item "/> Update Brew and install Git, Wget and other base level tools

  ```sh
  brew install git yarn make fastlane

  # now for the UI tools
  brew install clean-me visual-studio-code google-chrome iterm2 docker vlc postgres adoptopenjdk/openjdk/adoptopenjdk8
  ```

- <input type="checkbox" class="task-item "/> Add ZSH Suggestions

  ```sh
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

    # Add the following line to .zshrc
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh


  ```

- <input type="checkbox" class="task-item "/> Next up! Programming Language Support

  - Go Lang: https://golang.org/dl/

  - Node

    ```sh
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | zsh

    nvm install --lts
    nvm install 10
    nvm install 12
    nvm alias default 12 # most projects depend on this to be the min version for me right now
    ```

- <input type="checkbox" class="task-item "/> Copy back the .ssh folder in place and do a dummy connect to a certain project system for the ssh identities to be loaded automatically

- <input type="checkbox" class="task-item "/> Disable Keyboard corrections and other improvements from the keyboard settings

- <input type="checkbox" class="task-item "/> Oh, btw, did you enable opening apps from identified developers? Do it then!

- <input type="checkbox" class="task-item "/> Lets setup both the editors, restore the backed up editor configs from the pre-wipe, download the needed fonts for vscode and vim and while we are at hit, download Sublime Merge as well.

  - Not done yet!! who is going to install vim-plug? you think the plugins will just start working!?

  - [Download plug.vim](https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim) and put it in the "autoload" directory and then run the below command

    ```sh
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    ```

  - then we just open vim and run `:PlugInstall`

- <input type="checkbox" class="task-item "/> XCode and Android Studio, download them or check if the SSD has the latest version, if they're already there, let's create symlinks from there to the `$HOME/ExternalApplications` so we can save some space on the SSD.
- <input type="checkbox" class="task-item "/> Open XCode, change the derived data and archives folder to point to the external disk
- <input type="checkbox" class="task-item "/> Install ngrok - `brew install ngrok`

That's about it reaper, go sleep now, it's 4 in the morning, maybe start doing this a little early the next time.
