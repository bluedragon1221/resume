{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  outputs = inputs: let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs { inherit system; };
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = [
        pkgs.yaml-language-server
        pkgs.zathura
        pkgs.python313Packages.weasyprint
        pkgs.tera-cli
      ];
    };

    packages.${system} = {
      web = pkgs.runCommand "build-web" {
        buildInputs = with pkgs; [ tera-cli ];
        src = ./.;
      } ''
        make --makefile=$src/Makefile OBJDIR=$out SRCDIR=$src web
      '';

      pdf = pkgs.runCommand "build-pdf" {
        buildInputs = with pkgs; [ tera-cli python313Packages.weasyprint ];
        src = ./.;
      } ''
        make --makefile=$src/Makefile OBJDIR=$out pdf
      '';
    };
  };
}
