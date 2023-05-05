---
title: Linux and Installation Disks
date: 06/05/2023
published: true
---

Due to a recent unknown mishap my macbook decided to go blank on it's LCD. So
now, for portability I pulled out my linux "play"-station. Which I use for
various experiments with linux. Best part about it, is that it's formatted every
2 days so, I've never really used USB disks to install, it's mostly done in the
following manner.

## The Initial Requirement

The expectation is to at least have one system or at least grub on the system.
If by any chance you have nothing and are on Windows, I don't really have a
solution for you right now.

- Download a linux image.
- Mount it and note the paths to `vmlinuz` and `initrd`, we'll need these later.

## Setting up the Installation Partition

At this point, you can do 1 of 2 things.

1. Copy out the kernel and initrd images out and add them to your grub entry and
   then boot from it.
2. `dd` the image onto an empty partition and then boot into it using grub's CLI

I normally prefer the 2nd one since it's faster and I normally make sure there's
enough space to create a partition that can hold a linux install image (~4GB or
more)

Now, you create a partition using your favorite tool and `dd` the image onto
your partition

```sh
$ dd if=/image.iso of=/dev/sdXN
```

replace `sdXN`, `X` with the disk number and `N` with the partition.

Now you have a drive that can act as an installation drive.

## The Boot process.

At this point, there's 2 things we need to do.

1. Load the installation into the memory

- Load the linux kernel into the RAM
- Load the ram disk

2. Install it.

Let's get started.

1. Let the grub menu appear and then press `c` (generally the shortcode to open
   the grub CLI).
2. `ls` on the CLI to see the available disks
3. `ls (hd0,gpt1)` replace `hd0,gpt1` with whatever was listed by grub.
4. Continue going through the list till you see the Label of the image that was
   duplicated onto the partition.
5. When you find it, take note of the disk and now we boot the linux kernel out
   of it.

Set the root partition

```sh
grub> set root=(hd0,gpt1)
```

```sh
grub> linux /casper/vmlinuz toram quiet
```

replace `/casper/vmlinuz` with the path to `vmlinuz` for the distro you are
using. `casper/vmlinuz` is the general path for ubuntu based images.

Next up, we add in `initrd`

```sh
grub> initrd /casper/initrd
```

Now, the same applies here, you replace the path `/casper/` with the one for
your distro that you took note of in the starting.

At this point, all that's left is to boot into this drive.

```sh
grub> boot
```

If it all works well, and the kernel supports it, you should now have a linux
system running off your RAM and you can start the installation as a normal one ,
or keep it this way as a recovery partition.

If you wish for it to be a recovery partition, it'll be easier to add this in as
an entry to your grub config.

Hopefully this helps someone out, who'd like to fresh install and has no CD/DVD
or USB thumbdrive handy and needs to do a fresh install or just jump to a new
distro.
