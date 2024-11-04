{ pog, jq, cachix, git, ... }:

pog.pog {
  name = "cachix-push-om-outputs";
  description = "Foo bar";
  flags = [
    {
      name = "cache";
      description = "The name of the cachix cache to push to";
      argument = "CACHIX_CACHE";
    }
    {
      name = "subflake";
      description = "The name of the omnix CI subflake to use";
      argument = "SUBFLAKE";
    }
    {
      name = "prefix";
      description = "The prefix to use in conjunction with system string when pinning paths";
      argument = "PREFIX";
    }
  ];
  runtimeInputs = [ jq cachix git ];
  strict = true;
  script = helpers: ''
    blue "Parsing omnix JSON (subflake=$subflake)"
     
    STORE_PATHS=$(jq -r --arg prefix "$prefix" --arg name "$subflake" -f ${./script.jq})

    green "Pushing to https://''${cache}.cachix.org"
    echo "$STORE_PATHS" | jq -r --arg cache "$cache" '"cachix push \($cache) \(values | join(" "))"' | sh

    green "Pinning on https://''${cache}.cachix.org"
    echo "$STORE_PATHS" | jq -r --arg cache "$cache" 'to_entries[] | "echo '"'Pin \(.key) => \(.value)'"'; cachix pin -v \($cache) \(.key) \(.value)"' | sh
  '';
}
