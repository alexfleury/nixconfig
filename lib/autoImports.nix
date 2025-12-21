{ lib }:
let
  inherit (lib) hasPrefix hasSuffix filterAttrs mapAttrsToList;

  # Recursive function to collect .nix files from a given directory.
  # It excludes 'default.nix' and files starting with '_'.
  collectNixFiles = dir:
    let
      # Read all entries (files and directories) in the current directory and
      # process each entry to find .nix files or recurse into subdirectories.
      entries = builtins.readDir dir;

      files =
        mapAttrsToList
          (name: type:
            let
              # Construct the full path for the current entry.
              path = dir + "/${name}";
            in
              # Check if the entry is a regular file, ends with '.nix',
              # is not 'default.nix', and does not start with '_'.
              if type == "regular"
                && hasSuffix ".nix" name
                && name != "default.nix"
                && !(hasPrefix "_" name)
              then
                [ path ]
              # If the entry is a directory, recursively call collectNixFiles.
              else if type == "directory" then
                collectNixFiles path
              else
                [ ]
          )
          entries;
    in
      # Flatten the list of lists into a single list of file paths.
      builtins.concatLists files;
in
# The main function exported by this module. It takes a directory path and
# returns a list of discovered .nix file paths.
dir: collectNixFiles dir