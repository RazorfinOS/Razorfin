# RazorfinOS

> [!WARNING]
> **WORK IN PROGRESS - PROOF OF CONCEPT**
>
> RazorfinOS is currently in active development and is **not ready for production use**. This is an experimental proof of concept to explore bootc technology with Arch Linux. Expect breaking changes, incomplete features, and potential instability. Use at your own risk and do not rely on this for critical systems.

RazorfinOS is a desktop operating system built on Arch Linux using bootc (bootable container) technology. It delivers a modern, secure desktop experience with KDE Plasma, combining the power of Arch Linux with atomic updates and container-based system management.

**Note**: RazorfinOS is a fork of [HeliumOS](https://github.com/HeliumOS-org/HeliumOS), adapted for experimentation with bootc on Arch Linux.

## Key Features

### Immutability & Bootc Technology
- **Atomic Updates**: System updates are transactional and can be rolled back
- **Container-Based**: Built from OCI container images using bootc
- **OSTree Foundation**: Leverages ostree for reliable system versioning
- **Mutable Paths**: Strategic mutable directories (`/opt`, `/usr/addons`) for flexibility

### KDE Plasma Desktop Experience
- **Modern Desktop**: Full KDE Plasma desktop environment with Qt6
- **Rich Application Suite**: kde-applications, Kvantum theming, and curated defaults
- **SDDM Login Manager**: Customized display manager with overlay-mounted themes
- **Gaming Suite**: Built-in KDE games (KMines, Ksnakeduel, Ksudoku, Kreversi)

### Arch Linux Base & AUR Access
- **Rolling Release**: Built on Arch Linux for cutting-edge software
- **pacman Package Manager**: Fast, powerful package management
- **AUR Support**: Full access to the Arch User Repository via paru
- **Community Packages**: Thousands of packages at your fingertips

### Gaming & NVIDIA Support
- **NVIDIA Drivers**: Pre-built modules (standard) or DKMS (edge) variants
- **Steam Integration**: Steam udev rules for gaming hardware compatibility
- **Hardware Support**: Optimized for gaming peripherals and hardware

## System Variants

RazorfinOS is available in multiple variants to suit different needs:

### Standard
- **Stability-focused**: Uses stable kernel and pre-built NVIDIA modules
- **Faster Updates**: No driver compilation needed
- **Recommended**: Best for most users

### Canary
- **Development builds**: Bleeding-edge features from the `dev` branch
- **Early Access**: Test upcoming features before stable release
- **For testers**: Help shape RazorfinOS by testing new features

### Edge
- **Performance kernel**: Uses linux-zen for improved responsiveness
- **NVIDIA DKMS**: Drivers compiled on your system for latest compatibility
- **For enthusiasts**: Maximum performance and flexibility

## Installation

### Installing from ISO

1. **Download** the latest RazorfinOS ISO from releases
2. **Create bootable media** using your preferred tool (Ventoy, Rufus, dd)
3. **Boot from the media** and follow the Anaconda installer
4. **Customize** timezone, user account, and disk layout
5. **Reboot** into your new RazorfinOS system

### Direct Disk Installation

Install directly to a disk using bootc:

```bash
# Install to /dev/sda (replace with your target disk)
make install-to-disk DEVICE=/dev/sda
```

**Warning**: This will erase all data on the target disk.

### VM Installation

Create and boot a QEMU VM image:

```bash
# Create VM image (default: 100G qcow2 with ext4)
make create-vm-image

# Customize size, format, or filesystem
make create-vm-image SIZE=50G FORMAT=raw FILESYSTEM=btrfs

# Boot the VM
make boot-vm
```

**Supported Options**:
- `SIZE`: Disk size (default: 100G)
- `FORMAT`: Image format - qcow2 or raw (default: qcow2)
- `FILESYSTEM`: Filesystem type - ext4, btrfs, or xfs (default: ext4)

### Container Development

RazorfinOS includes Distrobox for container-based development:

```bash
# Create an Ubuntu container
distrobox create --name ubuntu --image ubuntu:latest

# Enter the container
distrobox enter ubuntu
```

### Flatpak Applications

Flathub is pre-configured for easy app installation:

```bash
# Install apps via Discover (GUI) or command line
flatpak install flathub org.mozilla.firefox
```

## Development

### Prerequisites

- **Podman** or compatible OCI container runtime
- **Make** for build automation
- **Git** for version control
- **Ansible** (included in container build)

### Building from Source

Clone the repository and build:

```bash
# Clone the repository
git clone https://github.com/yourusername/RazorfinOS.git
cd RazorfinOS

# Build the standard variant
make image

# Build canary variant
make image IS_CANARY=true

# Build edge variant
make image IS_EDGE=true

# Build canary edge variant
make image IS_CANARY=true IS_EDGE=true
```

### Available Make Targets

```bash
make image              # Build container image
make push               # Push image to registry
make iso                # Create installation ISO
make rechunk            # Optimize image layer structure
make install-to-disk    # Install to physical disk
make create-vm-image    # Create VM image
make boot-vm            # Boot VM with QEMU
make echo-image         # Display image name
make echo-tag           # Display image tag
make help               # Show help message
```

### Build Configuration

Key Makefile variables you can customize:

```makefile
IMAGE := ghcr.io/razorfinos/razorfin # Registry image name
IS_CANARY := true                     # Canary vs stable
IS_EDGE := false                      # Standard vs edge
VERSION := 1                          # Version number
ARCH := x86_64                        # Architecture
SIZE := 100G                          # VM image size
FORMAT := qcow2                       # VM image format
FILESYSTEM := ext4                    # Filesystem type
```

### CI/CD Workflows

RazorfinOS uses GitHub Actions for automated builds:

- **Canary Releases**: Triggered on push to `main` branch
- **Stable Releases**: Triggered on push to `stable` branch (also weekly)
- **ISO Builds**: Manual workflow dispatch
- **Image Signing**: All images signed with cosign

## Architecture

### Technology Stack

| Component | Technology |
|-----------|-----------|
| Base OS | Arch Linux |
| Container Tech | bootc (boot container) |
| Base Image | `ghcr.io/razorfinos/base:latest` |
| Config Management | Ansible |
| Desktop Environment | KDE Plasma |
| Package Manager | pacman + paru (AUR) |
| Security Framework | AppArmor |
| Container Registry | ghcr.io |
| Build System | Podman + Makefile |

### Directory Structure

```
RazorfinOS/
├── .github/workflows/    # CI/CD automation
├── playbooks/           # Ansible playbooks for variants
├── tasks/               # Modular Ansible tasks
│   ├── base/           # Common configuration
│   ├── edge/           # Edge variant tasks
│   ├── standard/       # Standard variant tasks
│   └── post/           # Post-installation tasks
├── files/              # Static system files
│   ├── etc/           # System configuration
│   └── usr/           # User space files
├── iso/                # ISO creation configuration
├── Makefile            # Build automation
├── Containerfile       # Container build definition
└── rechunk.sh          # Image optimization script
```

### Base Image

RazorfinOS uses a custom base image (`ghcr.io/razorfinos/base:latest`) that provides:

- **Clean pacman database**: All packages properly tracked
- **Pre-installed dependencies**: Common packages for faster builds
- **Proper bootc structure**: Correctly configured ostree/bootc layout
- **Maintained packages**: Regular updates with security patches

The base image is maintained in a separate repository: `../razorfinos-base/`

### Configuration Management

All system configuration is managed through Ansible:

- **Modular Tasks**: Each component is a separate task file
- **Variant Support**: Different playbooks for standard and edge variants
- **Idempotent**: Tasks can be run multiple times safely
- **Version Controlled**: All configuration tracked in git

Key task categories:
- Package management (pacman, AUR)
- Desktop environment (KDE Plasma, SDDM)
- Security (AppArmor, firewalld)
- Development tools (Docker, Distrobox)
- Gaming support (NVIDIA, Steam)
- Container support (Flatpak, Docker)

## Contributing

Contributions are welcome! Here's how you can help:

1. **Fork the repository** and create a feature branch
2. **Follow existing patterns** in `tasks/` directory
3. **Test your changes** with `make image` before committing
4. **Use Ansible** for all system configuration
5. **Document** your changes in commit messages
6. **Submit a pull request** to the `dev` branch

### Development Guidelines

- Use pacman for official Arch packages
- Use paru for AUR packages in task files
- Maintain AppArmor security profiles
- Follow existing Ansible task patterns
- Test all variants before release
- Keep commits atomic and well-described

## License

RazorfinOS is licensed under the GNU General Public License v2.0 (GPLv2).

Copyright © Ahmed Adan, 2025

See [LICENSE.md](LICENSE.md) for the full license text.

---

**RazorfinOS** - A modern, immutable desktop OS built on Arch Linux with bootc technology.
