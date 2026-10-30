<h1 align="center">NixOS</h1>

<p align="center">
  <i>"Multi-host" NixOS config built on Nix flakes, den and hjem.</i>
</p>

---

<p align="center">
  <img width="1200" alt="Desktop screenshot" src="https://github.com/user-attachments/assets/977364d5-ed61-4f05-9792-7056f9380bdd" />
</p>

## Info

- _Compositor_: [niri](https://github.com/niri-wm/niri)
- _Desktop_: [Dux Shell](https://duxlabs.dev/)
- _Terminal_: [Ghostty](https://ghostty.org/)
- _Theme_: [cyberdream](https://github.com/scottmckendry/cyberdream.nvim)
- _Editor_: [neovim](https://neovim.io/)

## Structure

- `modules/` — one file per den aspect (almost)
- `home/` — dotfiles managed by hjem
- `nvim/` — neovim config
- `overlays/` — package overlays

<p align="center">
  <sub>Built with <a href="https://github.com/NixOS/nix">Nix</a>, <a href="https://github.com/vic/den">den</a> &amp; <a href="https://github.com/feel-co/hjem">hjem</a>.</sub>
</p>
