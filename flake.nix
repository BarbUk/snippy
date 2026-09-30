{
  description = "Snippy Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      baseDeps = with pkgs; [
        rofi
        fzf
        jq
        gettext
        perl
      ];

      buildPackage =
        { x11, wayland }:
        let
          deps =
            baseDeps
            ++ (
              with pkgs;
              lib.optionals wayland [
                wtype
                wl-clipboard
              ]
            )
            ++ (
              with pkgs;
              lib.optionals x11 [
                xdotool
                xclip
                xsel
              ]
            );
        in
        pkgs.stdenv.mkDerivation {
          pname = "snippy";
          version = "git";

          nativeBuildInputs = [ pkgs.makeWrapper ];

          src = ./.;

          installPhase = ''
            mkdir -p $out/share/doc/snippy
            cp LICENSE $out/share/doc/snippy/LICENSE

            mkdir -p $out/bin
            cp snippy $out/bin

            wrapProgram $out/bin/snippy\
              --prefix PATH : ${pkgs.lib.makeBinPath deps}
          '';
          meta.license = pkgs.lib.licenses.gpl3Plus;
        };
    in
    {
      packages.${system} = {
        default = buildPackage {
          x11 = true;
          wayland = true;
        };
        wayland = buildPackage {
          x11 = false;
          wayland = true;
        };
        x11 = buildPackage {
          x11 = true;
          wayland = false;
        };
      };

      homeManagerModule =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        let
          cfg = config.programs.snippy;
        in
        {
          options.programs.snippy = {
            enable = lib.mkEnableOption "Whether to enable snippy snippets manager.";

            enableWayland = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Enable wayland support";
            };

            enableX11 = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Enable x11 support";
            };

            package = lib.mkOption {
              type = lib.types.package;
              default =
                let
                  selectedPackage = {
                    "true-false" = self.packages.${pkgs.system}.wayland;
                    "false-true" = self.packages.${pkgs.system}.x11;
                    "true-true" = self.packages.${pkgs.system}.default;
                    "false-false" = self.packages.${pkgs.system}.default;
                  };
                  key = "${lib.boolToString cfg.enableWayland}-${lib.boolToString cfg.enableX11}";
                in
                selectedPackage.${key};

              description = "Snippy package to install. Defaults to wayland + x11 support";
            };

            snippets = lib.mkOption {
              type = lib.types.attrsOf lib.types.lines;
              default = { };
              description = ''
                Declaratively define your snippets as
                programs.snippy.snippets."path/to/snippet" = 'echo "Hello from snippet"';
              '';
            };
          };

          config = lib.mkIf cfg.enable {
            home.packages = [ cfg.package ];
            home.file = lib.mapAttrs' (path: text: {
              name = ".config/snippy/${path}";
              value = { inherit text; };
            }) cfg.snippets;
          };
        };
    };
}
