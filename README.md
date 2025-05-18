# Cisco Packet Tracer Arch Installer

This script provides a simple and reliable way to install Cisco Packet Tracer on Arch Linux and its derivatives using the official `.deb` package provided by Cisco. It automates the extraction, dependency installation, and integration steps required to get Packet Tracer up and running as a native application with a desktop entry.

## Usage

```bash
chmod +x packettracer_installer.sh
sudo ./packettracer_installer.sh PacketTracer-8.2.1-ubuntu-64bit.deb
```

## Requirements

- `binutils` (provides the `ar` utility)
- Official Cisco Packet Tracer `.deb` package

## Features

- Verifies root privileges and user input
- Checks for required tools before proceeding
- Installs all necessary dependencies using `pacman`
- Extracts and installs Packet Tracer files from the official `.deb` package
- Automatically creates a desktop entry for easy launch from your application menu
- Cleans up temporary files after installation

## Disclaimer

This is not an official installer. Use at your own risk.  
Cisco Packet Tracer is proprietary software. Please ensure you have a valid license and obtain the `.deb` package from Cisco's official website.

---

## Author

[@Jovan Bogovac](https://github.com/pr00x)

## Contributing

Contributions are welcome! Please create a pull request or submit an issue for any feature requests or bug reports.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.