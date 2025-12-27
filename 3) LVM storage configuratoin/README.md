You are given an EC2 instance where the primary disk is used by the operating system, and an additional unused EBS disk has been attached. Your task is to prepare this new disk using LVM, without modifying the primary system disk. The final setup must include a logical volume for data storage and another logical volume dedicated to swap space.

1. Identify the new disk

  

Begin by confirming that the system detects the additional EBS disk. Note its device name and size, making sure it is not currently partitioned or in use. This disk will be configured entirely for LVM.

1. Initialize the disk as an LVM physical volume

Convert the new EBS disk into a physical volume. The entire disk will be assigned to LVM with no traditional partitions. This approach is recommended for cloud environments and simplifies future expansions.

1. Create a Volume Group

Create a new volume group using the physical volume you prepared. This volume group will serve as the pool of storage from which all logical volumes will be allocated.

1. Create Logical Volumes

Inside the volume group, create two separate logical volumes:

A swap logical volume, sized appropriately for system needs.

A logical volume, consuming most or all of the remaining available space.

These logical volumes will act as independent virtual block devices.

1. Configure the swap logical volume

Format the swap logical volume as swap space, activate it, verify that it is in use, and ensure that it will be automatically enabled whenever the system reboots.

1. Prepare the data logical volume

Format the data logical volume with a suitable file system such as XFS. Create a dedicated directory to serve as its mount point.

1. Mount the data file system

Mount the file system to its designated directory. Modify the system’s configuration to ensure that the data logical volume is mounted automatically at every boot.

1. Assign a practical use for the new data file system

Store application data, user files, or logs in the newly created file system. This validates the configuration and ensures the new storage is serving a productive purpose.




📌 1. Identify new disk
`lsblk` or `fdisk -l`

📌 2. Create physical volume
sudo `pvcreate DISK_DEVICE`
sudo `pvs`


Example: DISK_DEVICE=/dev/sdb

📌 3. Create volume group
sudo `vgcreate VG_NAME DISK_DEVICE`
sudo `vgs`


Example: VG_NAME=myvg

📌 4. Create logical volumes
Swap LV:
sudo `lvcreate -L 1G -n LV_SWAP_NAME VG_NAME`

Data LV:
sudo `lvcreate -l 100%FREE -n LV_DATA_NAME VG_NAME`


Verify:

sudo `lvs`

📌 5. Configure swap LV
Format swap:
sudo `mkswap /dev/VG_NAME/LV_SWAP_NAME`

Enable swap:
`sudo swapon /dev/VG_NAME/LV_SWAP_NAME`
`swapon --show`

Add swap to /etc/fstab:
`sudo blkid /dev/VG_NAME/LV_SWAP_NAME`


Add this line (using your UUID):

UUID=SWAP_UUID   none   swap   sw   0 0

📌 6. Configure data LV
Format LV as ext4:
`sudo mkfs.ext4 /dev/VG_NAME/LV_DATA_NAME`

Create mount directory:
`sudo mkdir -p MOUNT_POINT`

Mount it:
`sudo mount /dev/VG_NAME/LV_DATA_NAME MOUNT_POINT`


Verify:

`df -h`

📌 7. Make mount persistent
Get UUID:
sudo `blkid /dev/VG_NAME/LV_DATA_NAME`


Add to /etc/fstab:

UUID=DATA_UUID   MOUNT_POINT   ext4   defaults   0 0

🎉 Done — fully generic LVM workflow.