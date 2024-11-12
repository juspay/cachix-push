# Extract store paths along with their name from omnix CI json. Fail if the results encompass more than one system.
#
def get_transformed_key($base_key; $prefix; $sys):
  "\($prefix)-\($sys)-\($base_key)";

def filter_derivations($name; $derivation_list; $prefix; $sys):
    if ($derivation_list | keys | any(. == $name))
      then {
        key: get_transformed_key($name; $prefix; $sys),
        value: $derivation_list[$name]
      }
    else
        error("No such derivation with name: \($name)")
    end;

# Arguments:
# - $subflake: the subflake to use
# - $prefix: the prefix to use (usually git branch)
# - $derivations: optional list of names to filter by (if empty, all names are included)
if (.systems | length) != 1
    then error("systems array must have exactly 1 element")
else .systems[0] as $sys
    | ($derivations | split(" ")) as $drvs
    | .result[$subflake].build.byName as $byName
    | if ($drvs | length) == 0 then
        # If no derivations specified, return all entries with transformed keys
        $byName
        | to_entries
        | map({
            key: get_transformed_key(.key; $prefix; $sys),
            value: .value
          })
        | from_entries
      else
        # If derivations specified, return only those entries
        ($drvs | map(filter_derivations(.; $byName; $prefix; $sys)))
        | from_entries
      end
end
