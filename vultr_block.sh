#!/usr/bin/env bash

# Prepare the block storage
prepare_block_storage() {
    local device_name=$1

    # Verify the device name
    if [ ! -b "/dev/${device_name}" ]; then
        echo "Device /dev/${device_name} not found."
        return 1
    fi

    # Check if the device already has a partition
    if lsblk "/dev/${device_name}" | grep -q "part"; then
        echo "A partition already exists on /dev/${device_name}."
        return 1
    fi

    # Create a new disk label
    parted -s "/dev/${device_name}" mklabel gpt

    # Make a primary partition
    parted -s "/dev/${device_name}" unit mib mkpart primary 0% 100%

    # Create an EXT4 filesystem
    mkfs.ext4 "/dev/${device_name}1"
}

# Mount the block storage
mount_block_storage() {
    local device_name=$1
    local device_path="/dev/${device_name}1" # Assuming the first partition is to be mounted
    local mount_point_base="/mnt"
    local mount_point="${mount_point_base}/${device_name}"

    # Check if the device exists
    if [ ! -b "${device_path}" ]; then
        echo "Device ${device_path} not found."
        return 1
    fi

    # Create mount point
    mkdir -p "${mount_point}"

    # Add mount entry to /etc/fstab
    echo "${device_path} ${mount_point} ext4 defaults,noatime,nofail 0 0" >> /etc/fstab

    # Manually mount the block storage
    mount "${mount_point}"
}

lsblk
