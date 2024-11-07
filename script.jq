# Extract store paths along with their name from omnix CI json. Fail if the results encompass more than one system.
#
# Arguments:
# - $name: the subflake to use
# - $prefix: the prefix to use (usually git branch)
# - $derivations: optional list of names to filter by (if empty, all names are included)

def in_list($item; $derivations):
    ($derivations | split(" ")) | contains([$item]);

if (.systems | length) != 1 
    then error("systems array must have exactly 1 element") 
    else .systems[0] as $sys
        | $derivations as $drvs
        | .result[$name].build.byName
        | with_entries(
            select(
                ($drvs | length) == 0 or    # Include all if list is empty
                (.key | in_list(.; $drvs))  # Or if key is in derivations
            )
            | .key = "\($prefix)-\($sys)-" + .key
        )
end
