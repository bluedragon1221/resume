{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  outputs = inputs: let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs { inherit system; };
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = [
        pkgs.zathura
        pkgs.python313Packages.weasyprint
        pkgs.tera-cli
      ];
    };

    packages.${system} = let
      makeResumeBuilder = recipe: derivationArgs:
        pkgs.runCommand "build-${recipe}" ({ src = ./.; } // derivationArgs) ''
          make --makefile=$src/Makefile OBJDIR=$out SRCDIR=$src ${recipe}
        '';
    in {
      web = makeResumeBuilder "web" {
        buildInputs = [pkgs.tera-cli];
      };

      pdf = makeResumeBuilder "pdf" {
        buildInputs = [pkgs.tera-cli pkgs.python313Packages.weasyprint];
      };
    };
  };
}
