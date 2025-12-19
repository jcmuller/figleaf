{
  description = "figleaf - development and distribution";

  inputs = {
    devenv.url = "github:cachix/devenv";
    flake-parts.url = "github:hercules-ci/flake-parts";
    modules.url = "sourcehut:~jcmuller/modules";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = inputs @ {...}:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      debug = true;
      imports = [inputs.devenv.flakeModule];
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;

        devenv.shells.default = {
          imports = [inputs.modules.devenvModules.default];

          languages = {
            nix.enable = true;

            ruby = {
              enable = true;
              package = pkgs.ruby_3_4;
              bundler.enable = true;
            };
          };

          packages = with pkgs; [
            pkg-config
            cmake
            libyaml.dev
            openssl.dev
          ];

          enterShell = "bundle check || bundle install ";

          scripts = {
            run-test = {
              description = "run tests";
              exec = "bundle exec rspec";
            };

            run-package-artifacts = {
              description = "run tests";
              exec = "tar jcvf coverage.tar.bz2 coverage";
            };

            run-lint = {
              description = "ensure files are okay";
              exec = "bundle exec standardrb";
            };
          };
        };
      };
    };
}
