

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/Ogglord/nix">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">A simplistic NixOS config for 2024</h3>

  <p align="center">
    An awesome source of inspiration
    <br />
    <a href="https://github.com/Ogglord/nix/blob/main/"><strong>Explore the repo »</strong></a>
    <br />
    <br />
    <a href="https://github.com/Ogglord/nix/blob/main/flake.nix">flake.nix</a>
    ·
    <a href="https://github.com/Ogglord/nix/issues">Report Bug</a>
    ·
    <a href="https://github.com/Ogglord/nix/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Todo</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

There are many great nix configurations templates available on GitHub; however, this is mine.
I like it because:
* It is simplistic
* It is based on flakes, system and home-manager are (re)built together, always. Stop bothering with nixos-rebuild and home-manager switch
* Almost all packages and configuration are on user level either made through home-manager or custom code

Of course, no one nix config will serve everyones taste You may also suggest changes by forking this repo and creating a pull request or opening an issue. 

### Built With

 * nano
 * vs code
 * blood sweat and coffee

<!-- GETTING STARTED -->
## Getting Started

1. Install NixOS
2. Enable flakes
3. Setup your user with a passwd
4. Clone the repo
5. Make sure to update hardware-configuration.nix (!)
6. Tweak the username (<a href="https://github.com/Ogglord/nix/blob/main/nixos/configuration.nix">here</a>)
7. Build it

### How to build

To rebuild everything and switch to the new build
* full command
  ```nix
  nixos-rebuild switch .#<hostname>
  ```
* or use the alias
  ```bash
  rebuild
  ```

### Useful resources

<li><a href="https://search.nixos.org/packages?">nix Packages</a></li>
<li><a href="https://search.nixos.org/options?">NixOS Options</a></li>
<li><a href="https://nix-community.github.io/home-manager/options.xhtml">Home-Manager Options</a></li>
