# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };


  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.videoDrivers = [ "qxl" ];

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "alt-intl";
  };

  # Configure console keymap
  console.keyMap = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marcelo = {
    isNormalUser = true;
    description = "Marcelo";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [ 
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCVpR4ulb06keD1HORrzBjU14QPU1XLRvQItdDIsHq9UAZdxD3kntR685yMEC9TtnzhJsgZWmhTboZ2SPNoE840kE8bMbwqC1fmxX237qHFaZiu9Iknf5bFqwaQOf3Nv+neCLT3tEFkYHMEXAzl1TcOQA2oZtPK2jQ6MviVB17EthZNxbv9ClicJufMfU1cRpF1Lw+7f1l7LUNTYyjzYLxLBTM+BoccUl9Qu5Qk6b7hsgb7EpLWU9kKdAFs3xaoAdDDVAIqLsNBpx87+q+BZuPCvbhVpMh0lVN4h6pMlMcx2XIdu+X/SplKZaPQTsemjujtFhqdCjHNEt/ynZFWYIWG0pS1dzEtIEqMqNgG3zTCfz8t8JJGK6Lf8K/NqInZR9nqMZDHYyuCHJ8mTsiLzWJZ7A81+akFPBRZo1rNKBTPrixRllqhKdsGJgKDYEcR0tQi/FTl15aAZzvvdK7n98DrZ1iXd22lWpKEsCvkKYAApRbn2W3Tp2nmFk1LPe//4Cc=" ];
    packages = with pkgs; [
      firefox
      kitty
      sshfs
      vscode
    #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "marcelo";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    spice-vdagent
    qemu-utils
  ];

  # Enable QEMU tools
  # virtualization.qemu.guestAgent.enable = true;
  services.dbus.packages = with pkgs; [ gnome2.GConf ];
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = { 
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}
